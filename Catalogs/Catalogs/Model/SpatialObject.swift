//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import Foundation

@Observable final class SpatialObject: Codable, Identifiable, FileURLs {
    
    enum CodingKeys: String, CodingKey {
        case id
        case _title = "title"
    }
    
    let id: UUID
    var title: String
    
    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
}
