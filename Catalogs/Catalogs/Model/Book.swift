// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation
import Observation

@Observable class Book: Codable, Identifiable, FileURLProtocol {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case year
        case author
        case percentComplete
    }
    
    var id = UUID()
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
        self.title = title
        self.year = year
        self.author = author
        self.percentComplete = percentComplete
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        year = try container.decode(String.self, forKey: .year)
        author = try container.decode(String.self, forKey: .author)
        percentComplete = try container.decode(Double.self, forKey: .percentComplete)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(year, forKey: .year)
        try container.encode(author, forKey: .author)
        try container.encode(percentComplete, forKey: .percentComplete)
    }
}
