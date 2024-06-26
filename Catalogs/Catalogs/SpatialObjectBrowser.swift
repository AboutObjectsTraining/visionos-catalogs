//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct SpatialObjectBrowser: View {
    @Bindable var viewModel: CatalogsViewModel
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var objectsList: some View {
        List {
            ForEach(viewModel.objectCatalog.objects) { object in
                SpatialObjectCell(object: object)
                    .onTapGesture(perform: { show(object: object) })
            }
            .onMove { offsets, targetOffset in
                viewModel.moveObjects(fromOffsets: offsets, toOffset: targetOffset)
            }
            // A bit of a hack to work around absence of a hover effect
            // when the content isn't nested in a NavigationLink.
            // See also: SpatialObjectCell
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
                    // TODO: Implement 'Add 3D Model' sheet.
                    EditButton()
                    Button(action: { }) { Image.plus }
                    Text("\(viewModel.objectsCount) items")
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: toggleImmersiveSpace) {
                        Text("Dismiss Immersive Space")
                    }
                    .buttonStyle(.bordered)
                    .disabled(!viewModel.isShowingImmersiveSpace)
                }
            }
        }
        .onAppear { viewModel.loadObjects() }
    }
}

// MARK: - Actions
extension SpatialObjectBrowser {
    
    private func show(object: SpatialObject) {
        viewModel.selectedObject = object
        
        if !viewModel.isShowingImmersiveSpace {
            viewModel.isShowingImmersiveSpace = true
            
            Task {
                await openImmersiveSpace(id: SpaceID.spatialObjects)
            }
        }
    }
    
    @MainActor private func toggleImmersiveSpace() {
        Task {
            if viewModel.isShowingImmersiveSpace {
                viewModel.isShowingImmersiveSpace = false
                await dismissImmersiveSpace()
            } else {
                viewModel.isShowingImmersiveSpace = true
                await openImmersiveSpace(id: SpaceID.spatialObjects)
            }
        }
    }
}
