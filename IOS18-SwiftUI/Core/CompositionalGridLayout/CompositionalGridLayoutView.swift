//
//  CompositionalGridLayout.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 18/9/24.
//

import SwiftUI

struct CompositionalGridLayoutView: View {
    @State private var count: Int = 3
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 6) {
                PickerView()
                    .padding(.bottom)
                
                CompositionalLayout(count: count){
                    ForEach(1...50, id: \.self) { index in
                        Rectangle()
                            .fill(.black.gradient)
                            .overlay(
                                Text("\(index)")
                                    .font(.largeTitle.bold())
                                    .foregroundStyle(.white)
                            )
                    }
                }
                .animation(.bouncy, value: count)
            }
            .padding(15)
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
