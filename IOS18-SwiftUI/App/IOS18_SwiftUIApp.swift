//
//  IOS18_SwiftUIApp.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 17/9/24.
//

import SwiftUI

@main
struct IOS18_SwiftUIApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.isNetworkConnected, networkMonitor.isConnected)
                .environment(\.connectionType, networkMonitor.connectionType)
        }
    }
}
