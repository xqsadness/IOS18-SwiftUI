//
//  WaveformView.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 24/3/25.
//

import SwiftUI

struct WaveformView: View {
    @State private var progress: CGFloat = 0
    var body: some View {
        NavigationStack {
            List {
                if let audioURL {
                    Section("Audio") {
                        WaveformScrubber(url: audioURL, progress: $progress){ info in
                            
                        }onGestureActive: { status in
                            
                        }
                    }
                }
            }
        }
    }
    
    var audioURL: URL? {
        Bundle.main.url(forResource: "Audio", withExtension: "m4a")
    }
}

#Preview {
    WaveformView()
}
