//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct ThumbnailView: View {
    
    let artworkUrl: URL
    let width: CGFloat
    
    var body: some View {
        AsyncImage(url: artworkUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if phase.error == nil {
                ProgressView()
            } else {
                Placeholder()
            }
        }
        .cornerRadius(3)
        .frame(width: width, height: 100)
        .padding(.horizontal, 12)
    }
    
    struct Placeholder: View {
        
        var body: some View {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(.regularMaterial)
                Image(systemName: "photo")
                    .imageScale(.large)
            }
            .cornerRadius(8)
        }
    }
}

