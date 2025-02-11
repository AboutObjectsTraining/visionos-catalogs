//
//  Created 6/14/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI
import RealityKit

struct SpatialObjectsView: View {
    
    var viewModel: CatalogsViewModel
    
    @State private var baseTransform: Transform?
    
    private let defaultPosition: SIMD3<Float> = [0, 1.5, -1.5]
    
    var body: some View {
        
        RealityView { _ in
            // No default content
        } update: { content in
            guard viewModel.isShowingImmersiveSpace else { return }
            
            if let entity = loadSelectedObject() {
                content.add(entity)
            } else {
                print("Unable to load entity named \(viewModel.selectedObject?.title ?? "null")")
            }
        } placeholder: {
            ProgressView()
        }
        .gesture(dragGesture)
        .simultaneousGesture(rotateGesture)
        .simultaneousGesture(doubleTapGesture)
        .simultaneousGesture(tripleTapGesture)
    }
    
    private func loadSelectedObject() -> Entity? {
        guard let url = viewModel.selectedObject?.modelUrl,
              let entity = try? Entity.load(contentsOf: url)
        else {
            print("Unable to load \(String(describing: viewModel.selectedObject?.modelUrl))")
            return nil
        }
        
        configure(entity: entity)
        
        return entity
    }
    
    private func configure(entity: Entity) {
         
        entity.position = defaultPosition
        entity.scale = entity.scale(relativeTo: nil) * 2 // [0.02, 0.02, 0.02]

        // Handling gestures
        entity.generateCollisionShapes(recursive: true)
        entity.components.set(InputTargetComponent())
        
        // Custom components
        if entity.hasAnimation {
            entity.components.set(MyAnimationComponent())
        }

        // Casting shadows
        entity.enumerateHierarchy { entity in
            if entity is ModelEntity {
                entity.components.set(GroundingShadowComponent(castsShadow: true))
            }
        }
        
        // Image-based lighting
        //        Task {
        //            guard let resource = try? await EnvironmentResource(named: "Sunlight") else { return }
        //            let component = ImageBasedLightComponent(source: .single(resource),
        //                                                     intensityExponent: 9)
        //
        //            entity.components.set(component)
        //            entity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: entity))
        //        }
    }
}

// MARK: - Animation Support
struct MyAnimationComponent: Component {
    var isAnimating = false
}

extension Entity {
    
    var hasAnimation: Bool {
        components[MyAnimationComponent.self] != nil
    }
    
    var isAnimating: Bool {
        components[MyAnimationComponent.self]?.isAnimating ?? false
    }
    
    func toggleAnimation() {
        guard let animation = availableAnimations.first else { return }
        
        if isAnimating {
            stopAllAnimations()
        } else {
            playAnimation(animation.repeat(count: 0), transitionDuration: 1, startsPaused: false)
        }
        components[MyAnimationComponent.self] = MyAnimationComponent(isAnimating: !isAnimating)
    }
}

// MARK: - Gesture Support
extension SpatialObjectsView {
    
    var doubleTapGesture: some Gesture {
        TapGesture(count: 2)
            .targetedToAnyEntity()
            .onEnded { value in
                value.entity.toggleAnimation()
            }
    }
    
    var tripleTapGesture: some Gesture {
        TapGesture(count: 3)
            .targetedToAnyEntity()
            .onEnded { value in
                value.entity.removeFromParent()
            }
    }
    
    var rotateGesture: some Gesture {
        RotateGesture3D(constrainedToAxis: .y)
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = value.entity
                if baseTransform == nil {
                    baseTransform = entity.transform
                }
                
                let transform = Transform(AffineTransform3D(rotation: value.rotation))
                entity.transform.rotation = baseTransform!.rotation * transform.rotation
            }
            .onEnded { _ in
                baseTransform = nil
            }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = value.entity
                if baseTransform == nil {
                    baseTransform = entity.transform
                }
                
                let translation = value.convert(value.translation3D, from: .local, to: entity.parent!)
                entity.transform.translation = baseTransform!.translation + translation
            }
            .onEnded { _ in
                baseTransform = nil
            }
    }
}


#Preview("List", windowStyle: .automatic, traits: .fixedLayout(width: 600, height: 800)) {
    let viewModel = CatalogsViewModel()
    ContentView(viewModel: viewModel)
}
