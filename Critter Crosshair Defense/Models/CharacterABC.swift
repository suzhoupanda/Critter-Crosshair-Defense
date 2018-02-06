//
//  CharacterABC.swift
//  Critter Crosshair Defense
//
//  Created by Aleksander Makedonski on 2/4/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

class Character{
    
  
     let kMoveAnimation = "moveAnimation"
     let kRotateAnimation = "rotateAnimation"
     let kScaleAnimation = "scaleAnimation"
     let kTextureAnimation = "textureAnimation"
    
    var node: SKSpriteNode
    
    var name: String{
        
        return node.name!
        
    }
    
    private var animationsDict = [String: SKAction]()
 
    init(name: String, anchorPoint: CGPoint, zPosition: CGFloat, xScale: CGFloat, yScale: CGFloat){
        
        
        node = SKSpriteNode()
        
        node.name = name
        node.xScale = xScale
        node.yScale = yScale
        node.anchorPoint = anchorPoint
        node.zPosition = zPosition
        
    }
    
    func addCharacter(toScene scene: SKScene){
        self.node.move(toParent: scene)
    }
    
    func setPosition(at position: CGPoint){
        self.node.position = position
    }
    
    func runTextureAnimation(){
        if let textureAnimation = self.animationsDict[kTextureAnimation]{
            
            let repeatedAnimation = SKAction.repeatForever(textureAnimation)
            
            self.node.run(repeatedAnimation)

        }
    }
    
    func configureTexture(with texture: SKTexture){
        
        print("Setting the texture for the node...")
        
        node.texture = texture
        node.size = texture.size()
        
    }
    
    func configurePhysicsBody(physicsConfiguration: PhysicsConfiguration){
        
        guard let texture = node.texture else {
            return
        }
        
        let physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        
        physicsBody.categoryBitMask = UInt32(physicsConfiguration.categoryBitMask)
        physicsBody.collisionBitMask = UInt32(physicsConfiguration.collisionBitMask)
        physicsBody.contactTestBitMask = UInt32(physicsConfiguration.contactBitMask)
        
        physicsBody.affectedByGravity = physicsConfiguration.affectedByGravity
        physicsBody.allowsRotation = physicsConfiguration.allowsRotation
        physicsBody.isDynamic = physicsConfiguration.isDynamic
        
        physicsBody.angularDamping = physicsConfiguration.angularDamping
        physicsBody.linearDamping = physicsConfiguration.linearDamping
        
        physicsBody.velocity = physicsConfiguration.velocity
        physicsBody.angularVelocity = physicsConfiguration.angularVelocity
        
        physicsBody.friction = physicsConfiguration.friction
        physicsBody.restitution = physicsConfiguration.restitution
        
        physicsBody.mass = physicsConfiguration.mass
        physicsBody.charge = physicsConfiguration.charge
        physicsBody.density = physicsConfiguration.density
        
        
        node.physicsBody = physicsBody
        
    }
    
    
    func getAnimationsDictDebugString() -> String{
        
        return self.animationsDict.description
    }
    
    func configureAnimations(with animationGenerator: AnimationGenerator){
        
        if animationGenerator is MoveAnimationGenerator{
            
            self.animationsDict[kMoveAnimation] = animationGenerator.createAnimation()
        }
        
        if animationGenerator is RotateAnimationGenerator{
            
            self.animationsDict[kRotateAnimation] = animationGenerator.createAnimation()
            
        }
        
        if animationGenerator is ScaleAnimationGenerator{
            
            self.animationsDict[kScaleAnimation] = animationGenerator.createAnimation()
            
        }
        
        if animationGenerator is TextureAnimationGenerator{
            
            self.animationsDict[kTextureAnimation] = animationGenerator.createAnimation()
            
            
        }
        
    }

    
    func configureAnimations(with animationGenerators: [AnimationGenerator]){
        
        animationGenerators.forEach({
            
            if $0 is MoveAnimationGenerator{
                
                self.animationsDict[kMoveAnimation] = $0.createAnimation()
            }
            
            if $0 is RotateAnimationGenerator{
                
                self.animationsDict[kRotateAnimation] = $0.createAnimation()

            }
        
            if $0 is ScaleAnimationGenerator{
                
                self.animationsDict[kScaleAnimation] = $0.createAnimation()

            }
            
            if $0 is TextureAnimationGenerator{
                
                self.animationsDict[kTextureAnimation] = $0.createAnimation()

                
            }
            
        })
    }

}
