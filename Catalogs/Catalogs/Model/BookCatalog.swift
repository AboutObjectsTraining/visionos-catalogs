// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

@Observable final class BookCatalog: Codable, Identifiable, CustomStringConvertible
{
    // NOTE: @Observable property macros expand to insert @ObservationTracked
    // property macros for each read-write property. These in turn add underscore-prefixed
    // properties to store the actual values, as well as code to notify the ObservationRegistrar
    // of value changes.
    //
    enum CodingKeys: String, CodingKey {
        case id
        case _title = "title"
        case _books = "books"
    }
    
    let id: UUID
    var title: String
    var books: [Book]
    
    var hasBooks: Bool { !books.isEmpty }
    var description: String {
        "\n\(BookCatalog.self):\n\ttitle: \(title)\n\tbooks: \(books)\n"
    }
    
    init(id: UUID = UUID(), title: String, books: [Book]) {
        self.id = id
        self.title = title
        self.books = books
    }
}

// MARK: - Actions
extension BookCatalog {
    
    func add(book: Book) {
        books.insert(book, at: 0)
    }
    
    func remove(atOffsets indexSet: IndexSet) {
        books.remove(atOffsets: indexSet)
    }
    
    func move(fromOffsets offsets: IndexSet, toOffset offset: Int) {
        books.move(fromOffsets: offsets, toOffset: offset)
    }
}
