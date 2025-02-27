//
//  CompositionalLayout.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 18/9/24.
//

import SwiftUI

struct CompositionalLayout<Content: View>: View {
    var count: Int = 3
    var spacing: CGFloat = 6
    @ViewBuilder var content: Content
    @Namespace private var animation
    var body: some View {
        Group(subviews: content) { collection in
            let chunked = collection.chunked(count)
            
            ForEach(chunked) { chunk in
                switch chunk.layoutID {
                case 0: Layout1(chunk.collection)
                case 1: Layout2(chunk.collection)
                case 2: Layout3(chunk.collection)
                default: Layout4(chunk.collection)
                }
            }
        }
    }
    
    @ViewBuilder
    func Layout1(_ collection: [SubviewsCollection.Element]) -> some View {
        GeometryReader {
            let width = $0.size.width
            
            HStack(spacing: spacing) {
                if let first = collection.first {
                    first
                        .matchedGeometryEffect(id: first.id, in: animation)
                }
                
                VStack(spacing: spacing) {
                    ForEach(collection.dropFirst()) {
                        $0
                            .matchedGeometryEffect(id: $0.id, in: animation)
                            .frame(width: width * 0.33)
                    }
                }
            }
        }
        .frame(height: 200)
    }
    
    @ViewBuilder
    func Layout2(_ collection: [SubviewsCollection.Element]) -> some View {
        HStack(spacing: spacing) {
            ForEach(collection) {
                $0
                    .matchedGeometryEffect(id: $0.id, in: animation)
            }
        }
        .frame(height: 100)
    }
    
    @ViewBuilder
    func Layout3(_ collection: [SubviewsCollection.Element]) -> some View {
        GeometryReader {
            let width = $0.size.width - spacing
            
            HStack(spacing: spacing) {
                if let first = collection.first {
                    first
                        .matchedGeometryEffect(id: first.id, in: animation)
                        .frame(width: collection.count == 1 ? width : width * 0.33)
                }
                
                VStack(spacing: spacing) {
                    ForEach(collection.dropFirst()) {
                        $0
                            .matchedGeometryEffect(id: $0.id, in: animation)
                    }
                }
            }
        }
        .frame(height: 200)
    }
    
    @ViewBuilder
    func Layout4(_ collection: [SubviewsCollection.Element]) -> some View {
        HStack(spacing: spacing) {
            ForEach(collection) {
                $0
                    .matchedGeometryEffect(id: $0.id, in: animation)
            }
        }
        .frame(height: 230)
    }
}

fileprivate extension SubviewsCollection {
    func chunked(_ size: Int) -> [ChunkedCollection] {
        stride(from: 0, to: count, by: size).map {
            let collection = Array(self[$0..<Swift.min($0 + size, count)])
            let layoutID = ($0/size) % 4
            return .init(layoutID: layoutID, collection: collection)
        }
    }
    
    struct ChunkedCollection: Identifiable {
        var id: UUID = .init()
        var layoutID: Int
        var collection: [SubviewsCollection.Element]
    }
}

#Preview {
    CompositionalGridLayoutView()
}
