//
//  TextureProcessor.swift
//  Critter Crosshair Defense
//
//  Created by Aleksander Makedonski on 2/5/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class TextureConfigurationManager{
    
    
    let tConfigurations: [TextureConfiguration]
    
    
    init(withTextureConfigurations textureConfigurations: [TextureConfiguration]){
        self.tConfigurations = textureConfigurations
    }
    
    func getTextureAnimation(forTextureAnimationWith name: String, andOrientation orientation: Orientation, andTimePerFrame timerPerFrame: Double) -> TextureAnimationGenerator{
        
        let tConfigurations = self.tConfigurations.filter({$0.name == name && $0.orientation == orientation})
        
        let sortedTextureConfigurations = tConfigurations.sorted(by: {$0.order < $1.order})
        
        let textures = sortedTextureConfigurations.flatMap({$0.texture})
        
        return TextureAnimationGenerator(animationName: name, timePerFrame: timerPerFrame, textures: textures)
        
    }
    

    
    
}
