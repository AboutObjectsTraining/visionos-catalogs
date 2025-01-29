//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//

import SwiftUI

struct SpatialObjectBrowser: View {
    @Bindable var viewModel: CatalogsViewModel
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        
        NavigationStack {
            if !viewModel.objectCatalog.hasObjects {
                EmptyContentMessage(itemName: "3D model")
            } else {
                List {
                    ForEach(viewModel.objectCatalog.objects) { object in
                        SpatialObjectCell(object: object)
                            .onTapGesture {
                                show(object: object)
                            }
                    }
                    .onMove { offsets, targetOffset in
                        viewModel.moveObjects(fromOffsets: offsets, toOffset: targetOffset)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .padding(.bottom, 24)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(viewModel.navigationTitle)
                .toolbar {
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
                        Button(action: dismiss) {
                            Text("Dismiss Immersive Space")
                        }
                        .buttonStyle(.bordered)
                        .disabled(!viewModel.isShowingImmersiveSpace)
                    }
                }
            }
        }
    }
}

// MARK: - Actions
extension SpatialObjectBrowser {
    
    private func show(object: SpatialObject) {
        if !viewModel.isShowingImmersiveSpace {
            viewModel.isShowingImmersiveSpace = true
            Task {
                await openImmersiveSpace(id: SpaceID.spatialObjects)
            }
        }
        
        viewModel.selectedObject = object
    }
    
    @MainActor private func dismiss() {
        if viewModel.isShowingImmersiveSpace {
            viewModel.isShowingImmersiveSpace = false
            viewModel.selectedObject = nil
            Task {
                await dismissImmersiveSpace()
            }
        }
    }
}
