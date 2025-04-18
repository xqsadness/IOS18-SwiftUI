//
//  NetworkMonitor.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 18/4/25.
//

import Network
import SwiftUI

extension EnvironmentValues {
    @Entry var isNetworkConnected: Bool?
    @Entry var connectionType: NWInterface.InterfaceType?
}

class NetworkMonitor: ObservableObject {
    @Published var isConnected: Bool?
    @Published var connectionType: NWInterface.InterfaceType?
    
    /// Monitor Properties
    private var queue = DispatchQueue(label: "Monitor")
    private var monitor = NWPathMonitor()
    
    init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            Task { @MainActor in
                self.isConnected = path.status == .satisfied
                
                let types: [NWInterface.InterfaceType] = [.wifi, .cellular, .wiredEthernet, .loopback]
                if let type = types.first(where: { path.usesInterfaceType($0) }) {
                    self.connectionType = type
                } else {
                    self.connectionType = nil
                }
            }
        }
        
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
