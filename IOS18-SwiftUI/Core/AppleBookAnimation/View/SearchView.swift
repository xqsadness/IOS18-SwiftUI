//
//  SearchView.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 27/2/25.
//

import SwiftUI

struct SearchView: View {
    @State private var activeID: String? = books.first?.id
    @State private var scrollPosition: ScrollPosition = .init(idType: String.self)
    @State private var isAnyBookCardScrolled: Bool = false
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack(spacing: 4) {
                    ForEach(books) { book in
                        BookCardView(book: book, size: geometry.size){ isScrolled in
                            isAnyBookCardScrolled = isScrolled
                        }
                        .frame(width: geometry.size.width - 30)
                        // Let's Make currently active card to the top of the stack
                        .zIndex(activeID == book.id ? 1000 : 1)
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(15)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollPosition($scrollPosition)
            .scrollDisabled(isAnyBookCardScrolled)
            .onChange(of: scrollPosition.viewID(type: String.self)) { oldValue, newValue in
                activeID = newValue
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    AppleBookAnimation()
}
