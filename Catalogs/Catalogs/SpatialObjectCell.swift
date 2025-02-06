//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct SpatialObjectCell: View {
    let viewModel: CatalogsViewModel
    let object: SpatialObject
    
    var body: some View {
        // The ZStack here is a bit of a hack to work around absence
        // of a hover effect when not nested in a NavigationLink.
        ZStack {
            HStack {
                ThumbnailView(artworkUrl: object.artworkURL(ofType: "png"), width: 100)
                Spacer()
                Text("\(object.title)")
                    .font(.headline)
            }
            .padding()
            .padding(.horizontal, 12)
        }
        .background(.regularMaterial)
        .hoverEffect()
        .hoverEffectDisabled(!viewModel.isShowingImmersiveSpace)
    }
}
