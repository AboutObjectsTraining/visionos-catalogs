//
//  Created 6/11/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

@main struct CatalogsApp: App {
    
    @State private var viewModel = CatalogsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
        .defaultSize(width: 960, height: 680)
    }
}
