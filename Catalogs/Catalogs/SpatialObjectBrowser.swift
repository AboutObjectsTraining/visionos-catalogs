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
                        SpatialObjectCell(viewModel: viewModel, object: object)
                            .onTapGesture {
                                load(object: object)
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
                        Group {
                            if viewModel.isShowingImmersiveSpace {
                                Button("Dismiss Immersive Space", action: dismiss)
                                    .tint(.red)
                            } else {
                                Button("Launch Immersive Space", action: launch)
                                    .tint(.blue)
                            }
                        }
                        .padding(.bottom, 24)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .font(.title3)
                    }
                }
            }
        }
    }
}

// MARK: - Actions
extension SpatialObjectBrowser {
    
    private func launch() {
        guard !viewModel.isShowingImmersiveSpace else { return }
        
        viewModel.isShowingImmersiveSpace = true
        Task {
            await openImmersiveSpace(id: SpaceID.spatialObjects)
        }
    }
    
    private func dismiss() {
        guard viewModel.isShowingImmersiveSpace else { return }
        
        viewModel.isShowingImmersiveSpace = false
        viewModel.selectedObject = nil
        Task {
            await dismissImmersiveSpace()
        }
    }
    
    private func load(object: SpatialObject) {
        viewModel.selectedObject = object
        // Workaround for an issue where the second tap loads the
        // same object as the first regardless which row is tapped.
        DispatchQueue.main.async() {
            viewModel.selectedObject = nil
        }
    }
}
