// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

@Observable final class Book: Codable, Identifiable, FileURLs {
    
    enum CodingKeys: String, CodingKey {
        case id
        case _title = "title"
        case _year = "year"
        case _author = "author"
        case _percentComplete = "percentComplete"
    }
    
    let id: UUID
    var title: String
    var year: String
    var author: String
    var percentComplete = 0.0
    
    init(id: UUID = UUID(),
         title: String = "",
         year: String = "",
         author: String = "",
         percentComplete: Double = 0.0)
    {
        self.id = id
        self.title = title
        self.year = year
        self.author = author
        self.percentComplete = percentComplete
    }
}
