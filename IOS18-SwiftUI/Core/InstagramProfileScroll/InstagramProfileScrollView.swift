//
//  InstagramProfileScrollView.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 19/5/25.
//

import SwiftUI

struct InstagramProfileScrollView: View {
    var body: some View {
        HeaderPageScrollView(displaysSymbols: false) {
            RoundedRectangle(cornerRadius: 30)
                .fill(.blue.gradient)
                .frame(height: 350)
                .padding(15)
        } labels: {
            PageLabel(title: "Posts", symbolImage: "square.grid.3x3.fill")
            PageLabel(title: "Reels", symbolImage: "photo.stack.fill")
            PageLabel(title: "Tagged", symbolImage: "person.crop.rectangle")
        } pages: {
            /// Each View Represents Individual Tab View!
            DummyView(.red, count: 50)
            
            DummyView(.yellow, count: 10)
            
            DummyView(.indigo, count: 5)
        }onRefresh: {
            print("Referesh Data")
        }
    }
    
    /// Dummy Looping View
    @ViewBuilder
    private func DummyView(_ color: Color, count: Int) -> some View {
        LazyVStack(spacing: 12) {
            ForEach(0..<count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.gradient)
                    .frame(height: 45)
                    .contextMenu{
                        Button("aaa"){
                            
                        }
                    }
            }
        }
        .padding(15)
    }
}

#Preview {
    InstagramProfileScrollView()
}
