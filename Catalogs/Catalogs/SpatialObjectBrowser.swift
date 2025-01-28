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
                    .onTapGesture { show(object: object) }
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
    
    var body: some View {
        Group {
            if !viewModel.objectCatalog.hasObjects {
                EmptyContentMessage(itemName: "3D model")
            } else {
                objectsList
            }
        }
        .toolbar {
            if viewModel.selectedTab == .objects {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Text("\(viewModel.objectsCount) items")
                        .font(.headline)
                        .fixedSize()
                    Spacer()
                    EditButton()
                    // TODO: Implement 'Add 3D Model' sheet.
                    Button(action: { }) { Image.plus }
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
