//
//  CompositionalGridLayout.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 18/9/24.
//

import SwiftUI

struct CompositionalGridLayoutView: View {
    
    @State private var count: Int = 3
    @State private var isFullPresented = false
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 6) {
                PickerView()
                    .padding(.bottom)
                
                CompositionalLayout(count: count){
                    ForEach(0..<50, id: \.self) { index in
                        Image(.test)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, minHeight: 0)
                            .clipped()
                            .overlay(
                                Text("\(index)")
                                    .font(.largeTitle.bold())
                                    .foregroundStyle(.white)
                            )
                            .onTapGesture {
                                isFullPresented.toggle()
                            }
                    }
                }
                .animation(.bouncy, value: count)
            }
            .padding(15)
            .fullScreenCover(isPresented: $isFullPresented) {
                Image(.test)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .navigationTransition(.zoom(sourceID: UUID().uuidString, in: animation))
            }
        }
        .navigationTitle("Compositional Grid")
    }
    
    @ViewBuilder
    func PickerView() -> some View {
        Picker("", selection: $count) {
            ForEach(1...4, id: \.self) {
                Text("Count = \($0)")
                    .tag($0)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    CompositionalGridLayoutView()
}
