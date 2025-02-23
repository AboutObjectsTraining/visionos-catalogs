//
//  Created 6/11/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct SpaceID {
    static let spatialObjects = "Spatial Objects"
}

@main struct CatalogsApp: App {
    
    @State private var viewModel = CatalogsViewModel()
    @State private var immersionStyle: ImmersionStyle = .mixed

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .frame(minWidth: 600, maxWidth: 1000, minHeight: 500)
        }
        .defaultSize(width: 640, height: 960)
        .windowResizability(.contentSize)
        
        ImmersiveSpace(id: SpaceID.spatialObjects) {
            SpatialObjectsView(viewModel: viewModel)
        }
        .immersionStyle(selection: $immersionStyle, in: .mixed)
    }
    
    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }
}
