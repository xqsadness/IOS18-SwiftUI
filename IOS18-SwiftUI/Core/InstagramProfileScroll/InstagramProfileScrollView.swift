//
//  InstagramProfileScrollView.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 19/5/25.
//

import SwiftUI

struct InstagramProfileScrollView: View {
    
    @State private var displaysSymbols: Bool = true
    
    var body: some View {
        HeaderPageScrollView(displaysSymbols: displaysSymbols) {
            // Instagram Profile Header Layout
            dummyProfile()
        } labels: {
            PageLabel(title: "Posts", symbolImage: "square.grid.3x3.fill")
            PageLabel(title: "Reels", symbolImage: "photo.stack.fill")
            PageLabel(title: "Tagged", symbolImage: "person.crop.rectangle")
        } pages: {
            /// Each View Represents Individual Tab View!
            DummyView(.red, count: 50)
                .padding(.top)
            DummyView(.yellow, count: 10)
                .padding(.top)
            DummyView(.indigo, count: 5)
                .padding(.top)
        } onRefresh: {
            print("Referesh Data")
        }
    }
    
    private func dummyProfile() -> some View{
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                Image(.test)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                VStack(alignment: .leading, spacing: 4) {
                    Text("Xqsadness")
                        .font(.title2).bold()
                    HStack(spacing: 32) {
                        VStack {
                            Text("7,358").bold()
                            Text("posts").font(.caption).foregroundColor(.secondary)
                        }
                        VStack {
                            Text("1,6M").bold()
                            Text("followers").font(.caption).foregroundColor(.secondary)
                        }
                        VStack {
                            Text("2,155").bold()
                            Text("following").font(.caption).foregroundColor(.secondary)
                        }
                    }
                    Text("Public figure")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.horizontal, 8)
            
            HStack {
                Text("Display Symbols")
                    .font(.subheadline)
                Spacer()
                Toggle("", isOn: $displaysSymbols)
                    .labelsHidden()
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    /// Dummy Looping View
    @ViewBuilder
    private func DummyView(_ color: Color, count: Int) -> some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(0..<count, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(gradient: Gradient(colors: [color.opacity(0.7), .purple]), startPoint: .top, endPoint: .bottom))
                    .frame(height: 120)
            }
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    InstagramProfileScrollView()
}
