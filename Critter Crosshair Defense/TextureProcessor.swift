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
    
    
    let textureConfigurations: [TextureConfiguration]
    
    init(withTextureConfigurations textureConfigurations: [TextureConfiguration]){
        self.textureConfigurations = textureConfigurations
    }
    
    func getTextureAnimation(forTextureAnimationWith name: String, andOrientation orientation: Int, andTimePerFrame timerPerFrame: Double) -> TextureAnimation{
        
        let textureConfigs = textureConfigurations.filter({$0.name == name && $0.orientation == orientation})
        
        let sortedTextureConfigs = textureConfigs.sorted(by: {$0.order < $1.order})
        
        let textures = sortedTextureConfigs.flatMap({$0.texture})
        
        return TextureAnimation(animationName: name, timePerFrame: timerPerFrame, textures: textures)
        
    }
    
    
    
    

    
    
}
