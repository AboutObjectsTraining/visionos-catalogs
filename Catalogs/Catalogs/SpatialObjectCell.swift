//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct SpatialObjectCell: View {
    var object: SpatialObject
    
    var body: some View {
        HStack {
            ThumbnailView(artworkUrl: object.artworkURL(ofType: "png"), width: 100)

            Text("\(object.title)")
                .font(.headline)
        }
    }
}
