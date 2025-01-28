//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import Foundation

@Observable final class SpatialObjectCatalog: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case _title = "title"
        case _objects = "objects"
    }
    
    let id: UUID
    var title: String
    var objects: [SpatialObject]
    
    var hasObjects: Bool { !objects.isEmpty }
    
    init(id: UUID = UUID(), title: String, objects: [SpatialObject]) {
        self.id = id
        self.title = title
        self.objects = objects
    }
    
}

// MARK: - Actions
extension SpatialObjectCatalog {
    
    func move(fromOffsets offsets: IndexSet, toOffset offset: Int) {
        objects.move(fromOffsets: offsets, toOffset: offset)
    }
}
