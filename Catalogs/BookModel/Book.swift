// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

struct Book: Codable, Identifiable, Hashable {
    var id = UUID()
    var title: String
    var year: String
    var author: String
    var percentComplete = 0.0
    
    var artworkUrl: URL {
        let title = title.isEmpty ? "unknown" : title
        let url = Bundle.main.path(forResource: title, ofType: "jpg") ?? ""
        return URL(fileURLWithPath: url)
    }
//    
//    init(id: UUID = UUID(),
//         title: String = "",
//         year: String = "",
//         author: String = "",
//         percentComplete: Double = 0.0)
//    {
//        self.title = title
//        self.year = year
//        self.author = author
//        self.percentComplete = percentComplete
//    }
}
