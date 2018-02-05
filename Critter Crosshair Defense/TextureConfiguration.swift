//
//  TextureConfiguration.swift
//  Critter Crosshair Defense
//
//  Created by Aleksander Makedonski on 2/5/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

struct TextureConfiguration{
    
    var name: String
    var texture: SKTexture?
    var order: Int
    var orientation: Int
    
    
  
    
    static func == (left: TextureConfiguration, right: TextureConfiguration) -> Bool{
        return (left.name == right.name) && (left.orientation == right.orientation) && (left.order == right.order)
    }
    
    static func !=(left: TextureConfiguration, right: TextureConfiguration) -> Bool{
        return !(left == right)
    }

}
