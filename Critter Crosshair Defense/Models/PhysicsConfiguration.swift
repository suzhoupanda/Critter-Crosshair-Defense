//
//  PhysicsConfiguration.swift
//  Critter Crosshair Defense
//
//  Created by Aleksander Makedonski on 2/4/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit

struct PhysicsConfiguration{
    
    var categoryBitMask: Int32
    var collisionBitMask: Int32
    var contactBitMask: Int32
    var fieldBitMask: Int32
    
    var affectedByGravity: Bool
    var allowsRotation: Bool
    var isDynamic: Bool
    
    var angularDamping: CGFloat
    var linearDamping: CGFloat
    var friction: CGFloat
    var restitution: CGFloat
    
    var charge: CGFloat
    var mass: CGFloat
    var density: CGFloat
    
    var velocity: CGVector
    var angularVelocity: CGFloat
    
    
    
    init(withCategoryBitmask pCategoryBitMask: Int32, withCollisionBitMask pCollisionBitMask: Int32, andWithContactBitMask pContactBitMask: Int32, withFieldBitMask pFieldBitMask: Int32, pAffectedByGravity: Bool,allowsRotation pAllowsRotation: Bool, isDynamic pIsDynamic: Bool, angularDamping pAngularDamping: CGFloat, linearDamping pLinearDamping: CGFloat, friction pFriction: CGFloat, restitution pRestituion: CGFloat, charge pCharge: CGFloat, mass pMass: CGFloat, density pDesnity: CGFloat, velocity pVelocity: CGVector, angularVelocity pAngularVelocity: CGFloat) {
        
        self.categoryBitMask = pCategoryBitMask
        self.collisionBitMask = pCollisionBitMask
        self.contactBitMask = pContactBitMask
        self.fieldBitMask = pFieldBitMask
        
        self.affectedByGravity = pAffectedByGravity
        self.allowsRotation = pAllowsRotation
        self.isDynamic = pIsDynamic
        
        self.angularDamping = pAngularDamping
        self.linearDamping = pLinearDamping
        self.friction = pFriction
        
        self.charge = pCharge
        self.mass = pMass
        self.density = pDesnity
        self.restitution = pRestituion
        self.linearDamping = pLinearDamping
        
        self.velocity = pVelocity
        self.angularVelocity = pAngularVelocity
    }
    
}
