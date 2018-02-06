//
//  CharacterManagerDelegate.swift
//  Critter Crosshair Defense
//
//  Created by Aleksander Makedonski on 2/6/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation


protocol CharacterManagerDelegate: class {
    
    func didLoadTextureConfigurations()
    func didLoadCharacterDictionaryWith(_ character: Character)
    func didConfigurePhysicsFor(_ character: Character)
    func didConfigureTextureAnimationFor(_ character: Character)
    
}
