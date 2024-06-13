//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct SpatialObjectBrowser: View {
    @Bindable var viewModel: CatalogsViewModel
    @State private var selectedItemID: Set<UUID> = []
    
    var objectsList: some View {
        List(selection: $selectedItemID) {
            ForEach(viewModel.objectCatalog.objects) { object in
                NavigationLink {
                    Text("\(object.title)")
                        .font(.headline)
                } label: {
                    SpatialObjectCell(object: object)
                }
            }
//            .onMove { offsets, targetOffset in
//                viewModel.moveObjects(atOffsets: offsets, toOffset: targetOffset)
//            }
        }
        .padding(.bottom, 24)
    }
    
    var noObjectsMessage: some View {
        VStack {
            Spacer()
            Text("No 3D Models")
                .font(.headline)
            Text("Tap the + button to add a 3D model to the catalog.")
                .font(.subheadline)
            Spacer()
        }
    }
    
    var body: some View {
        VStack {
            if viewModel.objectCatalog.hasObjects {
                objectsList
            } else {
                noObjectsMessage
            }
        }
        .toolbar {
            if viewModel.selectedTab == .objects {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    // TODO: Implement Add 3D Model sheet.
                    EditButton()
                    Button(action: { }) { Image.plus }
                    Text("\(viewModel.objectsCount) items")
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: { }) { Text("Show Selected 3D Models") }
                        .buttonStyle(.bordered)
                }
            }
        }

//        .ornament(attachmentAnchor: .scene(.bottom), contentAlignment: .top) {
//            HStack {
//                Picker("", selection: $viewModel.presentationStyle) {
//                    Text("List")
//                        .tag(PresentationStyle.list)
//                    Text("Grid")
//                        .tag(PresentationStyle.grid)
//                }
//                .background(.thinMaterial, in: Capsule())
//            }
//            .padding(.horizontal, 12)
//            .frame(width: 240, height: 72)
//            .pickerStyle(.segmented)
//            .glassBackgroundEffect()
//        }
        .onAppear { viewModel.loadObjects() }
    }
}
