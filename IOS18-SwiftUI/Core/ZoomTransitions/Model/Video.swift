//
//  Video.swift
//  IOS18-SwiftUI
//
//  Created by darktech4 on 18/9/24.
//

import SwiftUI

struct Video: Identifiable, Hashable {
    var id: UUID = .init()
    var fileURL: URL
    var thumbnail: UIImage?
}

/// Sample Videos
let files = [
    URL(filePath: Bundle.main.path(forResource: "Video 1", ofType: "mp4") ?? ""),
    URL(filePath: Bundle.main.path(forResource: "Video 2", ofType: "mp4") ?? ""),
    URL(filePath: Bundle.main.path(forResource: "Video 1", ofType: "mp4") ?? ""),
    URL(filePath: Bundle.main.path(forResource: "Video 2", ofType: "mp4") ?? "")
].compactMap { Video(fileURL: $0) }
