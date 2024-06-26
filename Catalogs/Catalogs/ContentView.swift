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
            TabView(selection: $viewModel.selectedTab) {
                BookBrowser(viewModel: viewModel)
                    .tabItem {
                        Label("Books", systemImage: "books.vertical.fill")
                    }
                    .tag(Tab.books)
                SpatialObjectBrowser(viewModel: viewModel)
                    .tabItem {
                        Label("Models", systemImage: "view.3d")
                    }
                    .tag(Tab.objects)
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(Tab.settings)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(
                viewModel.selectedTab == .books
                ? viewModel.bookCatalog.title
                : viewModel.selectedTab.rawValue
            )
        }
        .frame(minWidth: 600, maxWidth: 1000, minHeight: 500)
    }
}


struct SettingsView: View {
    
    var body: some View {
        Text("Settings View")
    }
}

