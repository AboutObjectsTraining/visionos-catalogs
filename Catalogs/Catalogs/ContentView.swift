//
//  Created 6/11/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Bindable var viewModel: CatalogsViewModel
    
    var body: some View {
        NavigationStack {
            TabView {
                BookBrowser(viewModel: viewModel)
                    .tabItem {
                        Label("Books", systemImage: "books.vertical.fill")
                    }
                ObjectBrowser()
                    .tabItem {
                        Label("3D Models", systemImage: "view.3d")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .navigationTitle("Catalogs")
        }
    }
}


struct ObjectBrowser: View {
    
    var body: some View {
        Text("Object Browser")
    }
}

struct SettingsView: View {
    
    var body: some View {
        Text("Settings View")
    }
}

//#Preview(windowStyle: .automatic) {
//    ContentView()
//}
