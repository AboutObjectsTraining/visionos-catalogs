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
        TabView(selection: $viewModel.selectedTab) {
            BookBrowser(viewModel: viewModel)
                .tabItem {
                    Label("Books", systemImage: "books.vertical.fill")
                }
                .tag(Tab.books)
                .onAppear {
                    if !viewModel.hasBooks {
                        viewModel.loadBooks()
                    }
                }
            SpatialObjectBrowser(viewModel: viewModel)
                .tabItem {
                    Label("Models", systemImage: "view.3d")
                }
                .tag(Tab.objects)
                .onAppear {
                    if !viewModel.hasObjects {
                        viewModel.loadObjects()
                    }
                }
            SettingsBrowser()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
        .frame(minWidth: 600, maxWidth: 1000, minHeight: 500)
    }
}

