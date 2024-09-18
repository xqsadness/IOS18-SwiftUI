//
//  CustomVideoPlayerView.swift
//  IOS18-SwiftUI
//
//  Created by darktech4 on 18/9/24.
//

import SwiftUI
import AVKit

struct CustomVideoPlayerView: UIViewControllerRepresentable {
    @Binding var player: AVPlayer?

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}
