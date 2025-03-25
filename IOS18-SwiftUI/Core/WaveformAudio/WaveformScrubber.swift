//
//  WaveformScrubber.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 24/3/25.
//

import SwiftUI
import AVKit
import Combine

struct WaveformScrubber: View {
    var config: Config = .init()
    var url: URL
    @Binding var progress: CGFloat
    var info: (AudioInfo) -> () = { _ in }
    var onGestureActive: (Bool) -> () = { _ in }
    
    // view props
    @State private var samples: [Float] = []
    @State private var dowSizeSamples: [Float] = []
    @State private var viewSize: CGSize = .zero
    
    // gesture props
    @State private var lastProgress: CGFloat = 0
    @GestureState private var isActive: Bool = false
    
    // audio + timer
    @State private var audioPlayer: AVAudioPlayer? = nil
    @State private var audioDuration: Double = 1
    @State private var isPlaying: Bool = false
    @State private var timerCancellable: AnyCancellable? = nil
    
    var body: some View {
        VStack{
            VStack {
                ZStack {
                    WaveformShape(samples: dowSizeSamples)
                        .fill(config.inActiveTint)
                    WaveformShape(samples: dowSizeSamples)
                        .fill(config.activeTint)
                        .mask {
                            Rectangle()
                                .scale(x: progress, anchor: .leading)
                        }
                }
                .frame(maxWidth: .infinity)
                .contentShape(.rect)
                .gesture(
                    DragGesture()
                        .updating($isActive, body: { _, out, _ in })
                        .onChanged { value in
                            if isPlaying {
                                pauseAudio()
                            }
                            let p = max(min((value.translation.width / viewSize.width + lastProgress), 1), 0)
                            self.progress = p
                        }
                        .onEnded { _ in
                            lastProgress = progress
                            seekAudio()
                            onGestureActive(false)
                        }
                )
                .onChange(of: progress) { oldValue, newValue in
                    guard isActive else { return }
                    lastProgress = newValue
                }
                .onChange(of: isActive) { oldValue, newValue in
                    onGestureActive(newValue)
                }
                .onGeometryChange(for: CGSize.self) {
                    $0.size
                } action: { newValue in
                    if viewSize == .zero {
                        lastProgress = progress
                    }
                    viewSize = newValue
                    initializeAudioFile(newValue)
                }
            }
            .frame(height: 60)
            
            // Play/Pause button
            Button(action: {
                if isPlaying {
                    pauseAudio()
                } else {
                    playAudio()
                }
            }) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
    }
}

extension WaveformScrubber {
    private func playAudio() {
        guard let player = audioPlayer else { return }
        player.currentTime = Double(progress) * audioDuration
        player.play()
        isPlaying = true
        startProgressTimer()
    }
    
    private func pauseAudio() {
        audioPlayer?.pause()
        isPlaying = false
        stopProgressTimer()
    }
    
    private func seekAudio() {
        guard let player = audioPlayer else { return }
        player.currentTime = Double(progress) * audioDuration
    }
    
    private func startProgressTimer() {
        timerCancellable = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard let player = audioPlayer else { return }
                if player.isPlaying {
                    progress = CGFloat(player.currentTime / audioDuration)
                } else {
                    pauseAudio()
                }
            }
    }
    
    private func stopProgressTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    // Gọi sau khi load waveform xong
    private func setupAudioPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioDuration = audioPlayer?.duration ?? 1
        } catch {
            print("Failed to initialize player: \(error.localizedDescription)")
        }
    }
    
    private func initializeAudioFile(_ size: CGSize) {
        guard samples.isEmpty else { return }
        Task.detached(priority: .high) {
            do {
                let audioFile = try AVAudioFile(forReading: url)
                let audioInfo = extractAudioInfo(audioFile)
                let samples = try await extractAudioSamples(audioFile)
                let downSampleCount = Int(Float(size.width) / (config.spacing + config.shapeWidth))
                let downSample = downSampleAudioSamples(samples, downSampleCount)
                await MainActor.run {
                    self.samples = samples
                    self.dowSizeSamples = downSample
                    self.info(audioInfo)
                    setupAudioPlayer() // setup player sau khi waveform sẵn sàng
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct Config {
    var spacing: Float = 2
    var shapeWidth: Float = 2
    var activeTint: Color = .black
    var inActiveTint: Color = .gray.opacity(0.7)
    // OTHER CONFIGS....
}

struct AudioInfo {
    var duration: TimeInterval = 0
    // OTHER AUDIO INFO...
}

/// Custom WaveForm Shape
fileprivate struct WaveformShape: Shape {
    var samples: [Float]
    var spacing: Float = 2
    var width: Float = 2
    nonisolated func path(in rect: CGRect) -> Path {
        Path { path in
            var x: CGFloat = 0
            for sample in samples {
                let height = max(CGFloat(sample) * rect.height, 1)
                
                path.addRect(CGRect(
                    origin: .init(x: x + CGFloat(width), y: -height / 2),
                    size: .init(width: CGFloat(width), height: height)
                ))
                
                x += CGFloat(spacing + width)
            }
        }
        .offsetBy(dx: 0, dy: rect.height / 2)
    }
}

extension WaveformScrubber {
    nonisolated func extractAudioSamples(_ file: AVAudioFile) async throws -> [Float] {
        let format = file.processingFormat
        let frameCount = UInt32(file.length)
        
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)
        else { return [] }
        
        try file.read(into: buffer)
        
        if let channel = buffer.floatChannelData{
            let sample = Array(UnsafeBufferPointer(start: channel[0], count: Int(buffer.frameLength)))
            return sample
        }
        
        return []
    }
    
    nonisolated func downSampleAudioSamples(_ samples: [Float], _ count: Int) -> [Float] {
        let chunk = samples.count / count
        var downSamples: [Float] = []
        
        for index in 0..<count {
            let start = index * chunk
            let end = min((index + 1) * chunk, samples.count)
            let chunkSamples = samples[start..<end]
            
            let maxValue = chunkSamples.max() ?? 0
            downSamples.append(maxValue)
        }
        
        return downSamples
    }
    
    nonisolated func extractAudioInfo(_ file: AVAudioFile) -> AudioInfo {
        let format = file.processingFormat
        let sampleRate = format.sampleRate
        
        let duration = file.length / Int64(sampleRate )
        
        return .init(duration: TimeInterval(duration))
    }
}

#Preview {
    WaveformView()
}
