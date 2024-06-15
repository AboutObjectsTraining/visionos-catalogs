//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import Foundation
import Observation
import SwiftUI

@Observable class SpatialObject: Codable, Identifiable, FileURLProtocol {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
    
    var id = UUID()
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
    }
}
