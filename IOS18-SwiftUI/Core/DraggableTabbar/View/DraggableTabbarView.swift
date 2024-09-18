//
//  DraggableTabbarView.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 18/9/24.
//

import SwiftUI

struct DraggableTabbarView: View {
    
    var properties: TabProperties = .init()
    
    var body: some View {
        @Bindable var binding = properties
        VStack(spacing: 0){
            TabView(selection: $binding.activeTab) {
                Tab.init(value: 0){
                    Home()
                        .environment(properties)
                        .hideTabbar()
                }
                Tab.init(value: 1){
                    Text("Search")
                        .hideTabbar()
                }
                Tab.init(value: 2){
                    Text("Notifications")
                        .hideTabbar()
                }
                Tab.init(value: 3){
                    Text("Community")
                        .hideTabbar()
                }
                Tab.init(value: 4){
                    Text("Settings")
                        .hideTabbar()
                }
            }
            
            CustomDraggableTabbar()
                .environment(properties)
        }
    }
}

#Preview {
    DraggableTabbarView()
}
