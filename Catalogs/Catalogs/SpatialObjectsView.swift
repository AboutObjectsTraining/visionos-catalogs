//
//  Created 6/14/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI
import RealityKit

struct SpatialObjectsView: View {
    
    var viewModel: CatalogsViewModel
    @State private var baseTransform: Transform?
    @State private var baseMagnification: SIMD3<Float>?
    private let startPosition: SIMD3<Float> = SIMD3(x: 0, y: 1.5, z: -1.5)
    
    var magnifyGesture: some Gesture {
        MagnifyGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                if baseMagnification == nil {
                    baseMagnification = value.entity.scale
                }
                
                let delta = Float(value.magnification - 1)
                value.entity.scale = max(baseMagnification! + .init(repeating: delta), 0.2)
            }
            .onEnded { value in
                baseMagnification = nil
            }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .simultaneously(with: RotateGesture3D(constrainedToAxis: .y))
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = value.entity
                let rotation = value.second?.rotation
                let translation = value.first?.translation3D
                
                if baseTransform == nil {
                    baseTransform = entity.transform
                }
                
                if rotation != nil {
                    let rotationTransform = Transform(AffineTransform3D(rotation: rotation!))
                    entity.transform.rotation = baseTransform!.rotation * rotationTransform.rotation
                } else if translation != nil {
                    let convertedTranslation = value.convert(translation!, from: .local, to: entity.parent!)
                    entity.transform.translation = baseTransform!.translation + convertedTranslation
                }
            }
            .onEnded { _ in
                baseTransform = nil
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
        .gesture(magnifyGesture)
        .simultaneousGesture(dragGesture)
    }
    
    private func loadSelectedObject() -> Entity {
        guard let url = viewModel.selectedObject?.modelUrl,
              let entity = try? Entity.load(contentsOf: url) else {
            // let entity = try? Entity.loadModel(contentsOf: url) else {
            return Entity()
        }
        
        entity.position = startPosition
        configure(entity: entity)
        
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
        
        // print(entity.components)
    }
}
