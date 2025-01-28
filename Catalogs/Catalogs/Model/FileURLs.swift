//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import Foundation

protocol FileURLs {
    var title: String { get }
}

extension FileURLs {
    
    var artworkUrl: URL {
        let title = title.isEmpty ? "unknown" : title
        let url = Bundle.main.path(forResource: title, ofType: "jpg") ?? ""
        return URL(fileURLWithPath: url)
    }
    
    var modelUrl: URL {
        let title = title.isEmpty ? "unknown" : title
        let url = Bundle.main.path(forResource: title, ofType: "usdz") ?? ""
        return URL(fileURLWithPath: url)
    }
    
    func artworkURL(ofType type: String) -> URL {
        let title = title.isEmpty ? "unknown" : title
        let url = Bundle.main.path(forResource: title, ofType: type) ?? ""
        return URL(fileURLWithPath: url)
    }
}
