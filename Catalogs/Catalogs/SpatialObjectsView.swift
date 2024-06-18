//
//  Created 6/14/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI
import RealityKit

struct SpatialObjectsView: View {
    
    var viewModel: CatalogsViewModel
    @State private var currentTransform: Transform?
    @State private var currentMagnification: SIMD3<Float>?
    private let startPosition: SIMD3<Float> = SIMD3(x: 0, y: 1.5, z: -1.5)
    
    var magnifyGesture: some Gesture {
        MagnifyGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                if currentMagnification == nil {
                    currentMagnification = value.entity.scale
                }
                
                let delta = Float(value.magnification - 1)
                value.entity.scale = max(currentMagnification! + .init(repeating: delta), 0.2)
            }
            .onEnded { _ in
                currentMagnification = nil
            }
    }
    
    var rotateGesture: some Gesture {
        RotateGesture3D(constrainedToAxis: .y)
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = value.entity
                if currentTransform == nil {
                    currentTransform = entity.transform
                }
                
                let transform = Transform(AffineTransform3D(rotation: value.rotation))
                entity.transform.rotation = currentTransform!.rotation * transform.rotation
            }
            .onEnded { _ in
                currentTransform = nil
            }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = value.entity
                if currentTransform == nil {
                    currentTransform = entity.transform
                }
                
                let translation = value.convert(value.translation3D, from: .local, to: entity.parent!)
                entity.transform.translation = currentTransform!.translation + translation
            }
            .onEnded { _ in
                currentTransform = nil
            }
    }
    
    var body: some View {
        
        RealityView { _ in
            // We don't have any default content to load.
        } update: { content in
            let entity = loadSelectedObject()
            content.add(entity)
        } placeholder: {
            ProgressView()
        }
        .gesture(dragGesture)
        .simultaneousGesture(rotateGesture)
        .simultaneousGesture(magnifyGesture)
    }
    
    private func loadSelectedObject() -> Entity {
        guard let url = viewModel.selectedObject?.modelUrl,
              let entity = try? Entity.load(contentsOf: url)
        else {
            print("Unable to load \(String(describing: viewModel.selectedObject?.modelUrl))")
            return Entity()
        }
        
        entity.position = startPosition
        configure(entity: entity)
        
        print(entity)
        return entity
    }
    
    private func configure(entity: Entity) {
        entity.generateCollisionShapes(recursive: true)
        entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
        entity.components.set(HoverEffectComponent())
        
        entity.enumerateHierarchy { entity in
            if entity is ModelEntity {
                entity.components.set(GroundingShadowComponent(castsShadow: true))
            }
        }
        
        Task {
            guard let resource = try? await EnvironmentResource(named: "Sunlight") else { return }
            let component = ImageBasedLightComponent(source: .single(resource),
                                                     intensityExponent: 0.25)
            
            await entity.components.set(component)
            await entity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: entity))
        }
        
        entity.scale = entity.scale(relativeTo: nil) * 3 // [0.03, 0.03, 0.03]
    }
}
