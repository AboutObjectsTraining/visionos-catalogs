//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct ThumbnailView: View {
    
    let artworkUrl: URL
    let width: CGFloat
    
    private var thumbnailPlaceholder: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(.secondary)
            Image(systemName: "photo")
                .foregroundColor(.white)
                .imageScale(.large)
        }
        .cornerRadius(8)
    }

    var body: some View {
        AsyncImage(url: artworkUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if phase.error == nil {
                ProgressView()
            } else {
                thumbnailPlaceholder
            }
        }
        .cornerRadius(3)
        .frame(width: width, height: 100)
        .padding(.horizontal, 12)
    }
}
