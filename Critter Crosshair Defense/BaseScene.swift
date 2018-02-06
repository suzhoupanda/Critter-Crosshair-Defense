//
//  BaseScene.swift
//  Critter Crosshair Defense
//
//  Created by Aleksander Makedonski on 2/6/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class BaseScene: SKScene, CharacterManagerDelegate{
    
    let characterManager = CharacterManager()
    
    lazy var titleLabel: SKLabelNode = {
            let label = SKLabelNode(text: "Get ready to rumble...")
        
            label.fontName = "KohinoorDevanagari-Light"
            label.fontColor = UIColor.red
            label.fontSize = 15.0
        
            return label
    }()
    
    
    var randomPoint: CGPoint{
        
        let randomX = Int(arc4random_uniform(UInt32(400))) - 200
        let randomY = Int(arc4random_uniform(UInt32(600))) - 300
        
        return CGPoint(x: randomX, y: randomY)

    }
    
    override func didMove(to view: SKView) {
    
        self.backgroundColor = UIColor.cyan
        
        characterManager.delegate = self
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.titleLabel.move(toParent: self)
        
        characterManager.loadGameObjects()
        
    }
    
    
    func didLoadTextureConfigurations() {
        
        print("Textures have been loaded!")
        
        self.titleLabel.removeFromParent()
    }
    
    func didLoadCharacterDictionaryWith(_ character: Character) {
        
        print("Character dictionary loaded with: \(character.name)")
        
       
    }
    
    
    func didConfigurePhysicsFor(_ character: Character) {
        
        print("Configured physics for: \(character.name)")
        
        }
    
    
    func didConfigureTextureAnimationFor(_ character: Character) {
        
        print("Texture animation configure for: \(character.name)")
        
        character.addCharacter(toScene: self)
        
        character.setPosition(at: self.randomPoint)

        
        character.runTextureAnimation()
    }
    
}
