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
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    func navigationScreen<Content: View>(_ title: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        Button(action: {
            isSheetPresented = true
        }) {
            HStack {
                Text("\(title)")
                    .font(.title3)
                    .foregroundStyle(.text)
                
                Spacer()
                
                Image(systemName: "chevron.up")
                    .imageScale(.large)
                    .foregroundStyle(.text)
            }
        }
        .fullScreenCover(isPresented: $isSheetPresented) {
            content()
                .navigationTransition(.zoom(sourceID: UUID().uuidString, in: animation))
        }
    }
}

#Preview {
    ContentView()
}
