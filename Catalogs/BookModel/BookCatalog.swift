// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation
import Observation

@Observable class BookCatalog: Codable, Identifiable, CustomStringConvertible
{
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case books
    }
    
    var id = UUID()
    var title: String
    var books: [Book]
    
    var hasBooks: Bool { !books.isEmpty }
    var description: String {
        "\n\(BookCatalog.self):\n\ttitle: \(title)\n\tbooks: \(books)\n"
    }
    
    init(title: String, books: [Book]) {
        self.title = title
        self.books = books
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        books = try container.decode([Book].self, forKey: .books)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(books, forKey: .books)
    }
}

// MARK: - Actions
extension BookCatalog {
    
    func remove(atOffsets indexSet: IndexSet) {
        books.remove(atOffsets: indexSet)
        save()
    }
    
    func save() {
        // TODO: implement me!
    }
}
