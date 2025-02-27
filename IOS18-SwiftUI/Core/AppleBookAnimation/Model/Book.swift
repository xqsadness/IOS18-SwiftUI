//
//  Book.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 27/2/25.
//

import SwiftUI

struct Book: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var author: String
    var rating: String
    var thumbnail: String
    var color: Color
}

// Sample Data
let books: [Book] = [
    .init(
        title: "Breaking Bad ss5",
        author: "Vince Gilligan",
        rating: "5.0 (...) • Vince Gilligan",
        thumbnail: "Book 1",
        color: .book1
    ),
    .init(
        title: "Breaking Bad ss4",
        author: "Vince Gilligan",
        rating: "5.0 (6) • Vince Gilligan",
        thumbnail: "Book 2",
        color: .book2
    )
]

let dummyText: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
