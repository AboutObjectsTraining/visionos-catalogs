//
//  Created 6/15/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI
import RealityKit

extension Entity {
    
    /// Recursively descends an entity hierarchy.
    /// - Parameter callback: operation to perform on each entity in the hierarchy
    ///
    func enumerateHierarchy(_ callback: (Entity) -> Void) {
        enumerate(callback)
    }

    func enumerate(_ callback: (Entity) -> Void) {
        callback(self)
        children.forEach { $0.enumerateHierarchy(callback) }
    }
}

extension Entity {
    ///
    /// Adds an image-based light that emulates sunlight.
    ///
    /// This method assumes that the project contains a folder called
    /// `Sunlight.skybox` containing an image that defines a lighting source.
    ///
    /// Tune the `intensity` parameter to get the brightness that you want.
    /// Set `intensity` to `nil` to remove the image-based light from the entity.
    ///
    /// - Parameter intensity: The strength of the sunlight.
    ///
    func setSunlight(intensity: Float?) {
        
        guard let intensity else {
            components.remove(ImageBasedLightComponent.self)
            components.remove(ImageBasedLightReceiverComponent.self)
            return
        }
        
        Task {
            guard let resource = try? await EnvironmentResource(named: "Sunlight") else { return }
            let component = ImageBasedLightComponent(source: .single(resource),
                                                     intensityExponent: intensity)
            
            components.set(component)
            components.set(ImageBasedLightReceiverComponent(imageBasedLight: self))
        }
    }
}
