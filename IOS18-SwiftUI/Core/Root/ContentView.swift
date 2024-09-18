//
//  ContentView.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 17/9/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isSheetPresented = false
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    navigationScreen("Mesh Gradient") {
                        MeshGradientView()
                    }
                    
                    navigationScreen("Draggable Tabbar") {
                        DraggableTabbarView()
                    }
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    func navigationScreen<Content: View>(_ title: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        NavigationLink {
            content()
                .navigationBarBackButtonHidden()
                .navigationTransition(.zoom(sourceID: UUID().uuidString, in: animation))
        } label: {
            HStack {
                Text("\(title)")
                    .font(.title3)
                    .foregroundStyle(.text)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.large)
                    .foregroundStyle(.text)
            }
        }
    }
}

#Preview {
    ContentView()
}
