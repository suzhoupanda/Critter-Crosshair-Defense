//
//  Animation.swift
//  Critter Crosshair Defense
//
//  Created by Aleksander Makedonski on 2/4/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit

protocol AnimationGenerator{
    
    var animationName: String { get set }
    
    func createAnimation() -> SKAction?
    
}

struct TextureAnimation: AnimationGenerator{
    var animationName: String
    
    var hasSetTextureAnimation: Bool{
        
        return textures.count == 1
        
    }
    
    var hasAnimateWithTexturesAnimation: Bool{
        return textures.count > 1
    }
    
    var timePerFrame: Double
    var textures: [SKTexture]
    
    func createAnimation() -> SKAction? {
        
        if(textures.isEmpty){
            return nil
        }
        
        if(hasSetTextureAnimation){
            return SKAction.setTexture(textures.first!)
        } else {
            return SKAction.animate(with: self.textures, timePerFrame: self.timePerFrame)

        }
    }
    
    
    
}

struct RotateAnimation: AnimationGenerator{
    var animationName: String
    
    var hasRotateToAnimation: Bool{
        return rotateTo != nil
    }
    
    var hasRotateByAnimation: Bool{
        return rotateBy != nil
    }
    
    var rotateTo: Double?
    var rotateBy: Double?
    var shortestUnitArc: Bool = true

    var duration: Double
    
    func createAnimation() -> SKAction? {
        
        switch (self.rotateBy,self.rotateTo) {
        case (.some,.some):
            return createCombinedAnimation()
        case (.some,.none):
            return createRotateByAnimation()
        case (.none,.some):
            return createRotateToAnimation()
        default:
            return nil
        }
    }
    
    
    private func createCombinedAnimation() -> SKAction{
        
        return SKAction.group([
            self.createRotateByAnimation(),
            self.createRotateToAnimation()
            ])
        
    }
    
    private func createRotateByAnimation() -> SKAction{
        return SKAction.rotate(byAngle: CGFloat(self.rotateBy!), duration: self.duration)
       
    }
    
    private func createRotateToAnimation() -> SKAction{
        return SKAction.rotate(toAngle: CGFloat(self.rotateTo!), duration: self.duration, shortestUnitArc: self.shortestUnitArc)
        
    }
    
    
    
}


struct ScaleAnimation: AnimationGenerator{
    var animationName: String
    
    var hasScaleToAnimation: Bool{
        return xScaleTo != nil || yScaleTo != nil
    }
    
    var hasScaleByAnimation: Bool{
        return xScaleBy != nil || yScaleBy != nil
    }
    
    var xScaleTo: Double?
    var yScaleTo: Double?
    
    var xScaleBy: Double?
    var yScaleBy: Double?
    
    var duration: Double
    
    
    func createAnimation() -> SKAction? {
        
        if(hasScaleToAnimation && hasScaleByAnimation){
            return createCombinedAnimation()
        } else if hasScaleByAnimation{
            return createScaleByAnimation()
        } else if hasScaleToAnimation{
            return createScaleToAnimation()
        } else {
            return nil
        }
    }
    
    private func createCombinedAnimation() -> SKAction{
        
        return SKAction.group([
            self.createScaleByAnimation(),
            self.createScaleToAnimation()
            ])
        
    }
    
    private func createScaleByAnimation() -> SKAction{
        
        switch (self.xScaleBy,self.yScaleBy) {
        case (.some,.some):
            return SKAction.scaleX(by: CGFloat(self.xScaleBy!), y: CGFloat(self.yScaleBy!), duration: self.duration)
        case (.some,.none):
            return SKAction.scaleX(by: CGFloat(self.yScaleBy!), y: 0.00, duration: self.duration)
        case (.none,.some):
            return SKAction.scaleX(by: 0.00, y: CGFloat(self.yScaleBy!), duration: self.duration)
        default:
            return SKAction()
        }
        
    }
    
    private func createScaleToAnimation() -> SKAction{
        
        switch (self.xScaleTo,self.yScaleTo) {
        case (.some,.some):
            return SKAction.scaleX(to: CGFloat(self.xScaleTo!), y: CGFloat(self.yScaleTo!), duration: self.duration)
        case (.some,.none):
            return SKAction.scaleX(to: CGFloat(self.xScaleTo!), y: 0.00, duration: self.duration)
        case (.none,.some):
            return SKAction.scaleX(to: 0.00, y: CGFloat(self.yScaleTo!), duration: self.duration)
        default:
            return SKAction()
        }
        
    }
    
    
    
    
}

struct MoveAnimation: AnimationGenerator{
    
    var animationName: String
    
    var hasMoveToAnimation: Bool{
        return xMoveTo != nil || yMoveTo != nil
    }
    
    var hasMoveByAnimation: Bool{
        return xMoveBy != nil || yMoveBy != nil
    }
    
    var xMoveTo: Double?
    var yMoveTo: Double?

    var xMoveBy: Double?
    var yMoveBy: Double?
    
    var duration: Double
    
    func createAnimation() -> SKAction? {
        
        if(hasMoveToAnimation && hasMoveByAnimation){
            return createCombinedAnimation()
        } else if hasMoveByAnimation{
            return createMoveByAnimation()
        } else if hasMoveToAnimation{
            return createMoveToAnimation()
        } else {
            return nil
        }
        
        
    
    }
    
    private func createCombinedAnimation() -> SKAction{
        
       return SKAction.group([
            self.createMoveByAnimation(),
            self.createMoveToAnimation()
        ])
    }
    
    private func createMoveByAnimation() -> SKAction{
        
        switch (self.xMoveBy,self.yMoveBy) {
        case (.some,.some):
            return SKAction.moveBy(x: CGFloat(self.xMoveBy!), y: CGFloat(self.yMoveBy!), duration: self.duration)
        case (.some,.none):
            return SKAction.moveBy(x: CGFloat(self.xMoveBy!), y: 0.00, duration: self.duration)
        case (.none,.some):
            return SKAction.moveBy(x: 0.00, y: CGFloat(self.yMoveBy!), duration: self.duration)
        default:
            return SKAction()
        }
    }
    
    
    func createMoveToAnimation() -> SKAction{
        
        switch (self.xMoveBy,self.yMoveBy) {
        case (.some,.some):
            return SKAction.move(to: CGPoint(x: CGFloat(self.xMoveBy!), y: CGFloat(self.yMoveBy!)), duration: self.duration)
        case (.some,.none):
            return SKAction.moveTo(x: CGFloat(self.xMoveTo!), duration: self.duration)
        case (.none,.some):
            return SKAction.moveTo(y: CGFloat(self.yMoveTo!), duration: self.duration)
        default:
            return SKAction()
        }
        
    }
    
    
}




