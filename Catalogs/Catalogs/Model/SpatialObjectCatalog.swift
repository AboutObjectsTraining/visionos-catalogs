//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import Foundation
import Observation

@Observable class SpatialObjectCatalog: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case objects
    }
    
    var id = UUID()
    var title: String
    var objects: [SpatialObject]
    
    init(title: String, objects: [SpatialObject]) {
        self.title = title
        self.objects = objects
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        objects = try container.decode([SpatialObject].self, forKey: .objects)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(objects, forKey: .objects)
    }
}