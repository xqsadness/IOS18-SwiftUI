//
//  ContentView.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 17/9/24.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.isNetworkConnected) private var isConnected
    @Environment(\.connectionType) private var connectionType
    @State private var isFullPresented = false
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            VStack{
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 15) {
                        navigationScreen("Mesh Gradient") {
                            MeshGradientView()
                        };
                        
                        navigationScreen("Draggable Tabbar") {
                            DraggableTabbarView()
                        }
                        
                        HStack {
                            Text("Zoom Transitions")
                                .font(.title3)
                                .foregroundStyle(.text)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .imageScale(.large)
                                .foregroundStyle(.text)
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            isFullPresented.toggle()
                        }
                        
                        navigationScreen("Compositional Layout") {
                            CompositionalGridLayoutView()
                        }
                        
                        navigationScreen("ToastView") {
                            ToastView()
                        }
                        
                        navigationScreen("Custom Alert") {
                            CustomAlertView()
                        }
                        
                        navigationScreen("Apple Book Animation") {
                            AppleBookAnimation()
                        }
                        
                        navigationScreen("VisionOS Style Menu") {
                            VisionOSStyleMenu()
                        }
                        
                        navigationScreen("Waveform Audio") {
                            WaveformView()
                        }
                        
                        navigationScreen("Dynamic Floating Sheet") {
                            DynamicFloatingSheetsView()
                        }
                        
                        navigationScreen("Home Control Slider") {
                            HomeControlSlider()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("IOS18, SWIFTUI")
            .fullScreenCover(isPresented: $isFullPresented) {
                ZoomTransitionsView()
            }
        }
        .sheet(isPresented: .constant(!(isConnected ?? true))) {
            NoInternetView()
                .presentationDetents([.height(310)])
                .presentationCornerRadius(0)
                .presentationBackgroundInteraction(.disabled)
                .presentationBackground(.clear)
                .interactiveDismissDisabled()
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
