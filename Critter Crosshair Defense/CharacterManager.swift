//
//  CharacterManager.swift
//  Critter Crosshair Defense
//
//  Created by Aleksander Makedonski on 2/4/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import CloudKit


class CharacterManager{
    
    
    var publicDB = CKHelper.sharedHelper.publicDB
    var backgroundQueue = OperationQueue()
    var characterDict = [String:Character]()
    
   
    
    lazy var allCharactersQuery: CKQuery = {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "CharacterABC", predicate: predicate)
        
        return query
        
    }()
    
    func loadCharacters(){
        
        print("Preparing to load characters....")

        self.publicDB.perform(self.allCharactersQuery, inZoneWith: nil){
            
            records, error in
            
            if(error != nil){
                
                print(error!.localizedDescription)
                
            } else {
                
                if let ckRecords = records, ckRecords.count > 0{
                    
                    ckRecords.forEach({
                        
                        self.loadCharacter(from: $0)
                        
                    })
                }
            }
            
            
        }
    }
    
    func loadCharacter(from ckRecord: CKRecord){
        
        print("Preparing to load character from record....")
      
        guard let anchorPointStr = ckRecord.value(forKey: "anchorPoint") as? String,
            let zPosition = ckRecord.value(forKey: "zPosition") as? Double,
            let xScale = ckRecord.value(forKey: "xScale") as? Double,
            let yScale = ckRecord.value(forKey: "yScale") as? Double,
            let charName = ckRecord.value(forKey: "name") as? String else {
            return
        }
      
        let anchorPoint = CGPointFromString(anchorPointStr)

        
        let character = Character(name: charName, anchorPoint: anchorPoint, zPosition: CGFloat(zPosition), xScale: CGFloat(xScale), yScale: CGFloat(yScale))
        

        //Create an operation to load the character's default texture
        let ckTexture = CKTexture(with: ckRecord)
        let loadTextureOperation = LoadTextureOperation(with: ckTexture)
        
        
        loadTextureOperation.completionBlock = {
            
            if ckTexture.isDownloaded,let texture = ckTexture.texture{
                character.configureTexture(with: texture)
            }
            
            print("Finished loading the texture")
        }
        
    
        
        let configurePhysicsOperation = createConfigurePhysicsOperation(forCharacter: character, andCKRecord: ckRecord){
            
            self.characterDict[character.name] = character
            
            print("Print finished loading character into dictionary: \(self.characterDict.description)")
        }
        
        let configureMoveAnimationOperation = createConfigureMoveAnimationsOperation(forCharacter: character, andCKRecord: ckRecord){
            
            print("Configured the move operation")
        }
        
    
        let configureRotateAnimationOperation = createConfigureRotateAnimationsOperation(forCharacter: character, andCKRecord: ckRecord){
            
            print("Configured the rotate operation")

        }
        
        let configureScaleAnimationOperation = createConfigureScaleAnimationsOperation(forCharacter: character, andCKRecord: ckRecord){
            
            print("Configured the scale operation")

        }
        
        let configureTextureAnimationsOperaiton = createConfigureTextureAnimationsOperation(forCharacter: character, andCKRecord: ckRecord){
            
            print("Configured the texture operation")

        }
    
        //Configure dependencies for all the operations
        configurePhysicsOperation.addDependency(loadTextureOperation)
        configureMoveAnimationOperation.addDependency(configurePhysicsOperation)
        configureScaleAnimationOperation.addDependency(configureMoveAnimationOperation)
        configureRotateAnimationOperation.addDependency(configureScaleAnimationOperation)
        configureTextureAnimationsOperaiton.addDependency(configureRotateAnimationOperation)
        
        //Add operations to the background queue
        backgroundQueue.addOperation(loadTextureOperation)
        backgroundQueue.addOperation(configurePhysicsOperation)
        backgroundQueue.addOperation(configureMoveAnimationOperation)
        backgroundQueue.addOperation(configureScaleAnimationOperation)
        backgroundQueue.addOperation(configureRotateAnimationOperation)
        backgroundQueue.addOperation(configureTextureAnimationsOperaiton)
        
        
    }
    
    
    func createConfigureTextureAnimationsOperation(forCharacter character: Character, andCKRecord ckRecord: CKRecord, andCompletionHandler completionHandler: @escaping ()->(Void)) -> CKQueryOperation{
        
        let recordID = ckRecord.recordID
        
        let ckReference = CKReference(recordID: recordID, action: CKReferenceAction.deleteSelf)
        
        let predicate = NSPredicate(format: "character == %@", ckReference)
        
        let query = CKQuery(recordType: "AnimationTextureABC", predicate: predicate)
        
        let ckQueryOperation = CKQueryOperation(query: query)
 
        
        var textureConfigurations = [TextureConfiguration]()
        
        ckQueryOperation.recordFetchedBlock = {
            
            record in
            
            guard let name = record.value(forKey: "animationName") as? String, let orientation = record.value(forKey: "orientation") as? Int64, let order = record.value(forKey: "order") as? Int64 else {
                
                return
                
            }
            
            var texture: SKTexture?
            
            if let asset = record.value(forKey: "texture") as? CKAsset,let imageData = NSData(contentsOf: asset.fileURL),let image = UIImage(data: imageData as Data){
               
                texture = SKTexture(image: image)
               
            }
            
           
            let textureConfiguration = TextureConfiguration(name: name, texture: texture, order: Int(order), orientation: Int(orientation))
            
            textureConfigurations.append(textureConfiguration)
            
        }
        
        let tcm = TextureConfigurationManager(withTextureConfigurations: textureConfigurations)
    
    
        ckQueryOperation.completionBlock = {
            
            let textureAnimation = tcm.getTextureAnimation(forTextureAnimationWith: "textureAnimation", andOrientation: 0, andTimePerFrame: 1.00)
            
            character.configureAnimations(with: textureAnimation)
            
            completionHandler()
        }
        
        return ckQueryOperation
    }
    
    
    
    
    func createConfigureScaleAnimationsOperation(forCharacter character: Character, andCKRecord ckRecord: CKRecord, andCompletionHandler completionHandler: @escaping ()->(Void)) -> CKQueryOperation{
        
        
        let ckScaleAnimationReference = CKReference(record: ckRecord, action: CKReferenceAction.deleteSelf)
        
        let predicate = NSPredicate(format: "characterABC == %@", ckScaleAnimationReference)
        
        let query = CKQuery(recordType: "ScaleAnimationABC", predicate: predicate)
        
        let ckQueryOperation = CKQueryOperation(query: query)
        
        ckQueryOperation.resultsLimit = 1
        
        ckQueryOperation.recordFetchedBlock = {
            
            record in
            
            
            guard let duration = record.value(forKey: "duration") as? Double, let animationName = record.value(forKey: "animationName") as? String else { return }
            
            let xScaleBy = record.value(forKey: "xScaleBy") as? Double
            let xScaleTo = record.value(forKey: "xScaleTo") as? Double
            let yScaleBy = record.value(forKey: "yScaleBy") as? Double
            let yScaleTo = record.value(forKey: "yScaleTo") as? Double
            
            let scaleAnimationGenerator = ScaleAnimation(animationName: animationName, xScaleTo: xScaleTo, yScaleTo: yScaleTo, xScaleBy: xScaleBy, yScaleBy: yScaleBy, duration: duration)


            character.configureAnimations(with: scaleAnimationGenerator)

            
        }
        
        
        ckQueryOperation.completionBlock = {
            
            completionHandler()
        }
        
        return ckQueryOperation
    }
    
    
    func createConfigureMoveAnimationsOperation(forCharacter character: Character, andCKRecord ckRecord: CKRecord, andCompletionHandler completionHandler: @escaping ()->(Void)) -> CKQueryOperation{
        
        let ckMoveAnimationReference = CKReference(record: ckRecord, action: CKReferenceAction.deleteSelf)
        
        let predicate = NSPredicate(format: "characterABC == %@", ckMoveAnimationReference)
        
        let query = CKQuery(recordType: "MoveAnimationABC", predicate: predicate)
        
        
        let ckQueryOperation = CKQueryOperation(query: query)
        
        ckQueryOperation.resultsLimit = 1
        
        ckQueryOperation.recordFetchedBlock = {
            
            record in
            
            guard let duration = record.value(forKey: "duration") as? Double, let animationName = record.value(forKey: "animationName") as? String else {
                    return
            }
            
            let xMoveBy = record.value(forKey: "xMoveBy") as? Double
            let xMoveTo = record.value(forKey: "xMoveTo") as? Double
            let yMoveBy = record.value(forKey: "yMoveBy") as? Double
            let yMoveTo = record.value(forKey: "yMoveTo") as? Double

            let moveAnimationGenerator = MoveAnimation(animationName: animationName, xMoveTo: xMoveTo, yMoveTo: yMoveTo, xMoveBy: xMoveBy, yMoveBy: yMoveBy, duration: duration)

            character.configureAnimations(with: moveAnimationGenerator)
            
            
        }
        
        ckQueryOperation.completionBlock = {
            
            completionHandler()
        }
        
        return ckQueryOperation
    }
    
    func createConfigureRotateAnimationsOperation(forCharacter character: Character, andCKRecord ckRecord: CKRecord, andCompletionHandler completionHandler: @escaping ()->(Void)) -> CKQueryOperation{
        
        let ckRotateAnimationReference = CKReference(record: ckRecord, action: CKReferenceAction.deleteSelf)
        
        let predicate = NSPredicate(format: "characterABC == %@", ckRotateAnimationReference)
        
        let query = CKQuery(recordType: "RotateAnimationABC", predicate: predicate)
        
        
        let ckQueryOperation = CKQueryOperation(query: query)
        
        ckQueryOperation.resultsLimit = 1
        
        ckQueryOperation.recordFetchedBlock = {
            
            record in
            
            
            guard let duration = record.value(forKey: "duration") as? Double, let animationName = record.value(forKey: "animationName") as? String else { return }
            
            let rotateByAngle = record.value(forKey: "rotateByAngle") as? Double
            let rotateToAngle = record.value(forKey: "rotateToAngle") as? Double
            
            let rotateAnimationGenerator = RotateAnimation(animationName: animationName, rotateTo: rotateToAngle, rotateBy: rotateByAngle, shortestUnitArc: true, duration: duration)
            
            character.configureAnimations(with: rotateAnimationGenerator)
        }
        
        ckQueryOperation.completionBlock = {
            
            completionHandler()
        }
        
        return ckQueryOperation
        
        
    }
    
   
    func createConfigurePhysicsOperation(forCharacter character: Character, andCKRecord ckRecord: CKRecord, andCompletionHandler completionHandler: @escaping ()->(Void)) -> CKQueryOperation{
        
        let recordID = ckRecord.recordID
        
        let characterRef = CKReference(recordID: recordID, action: CKReferenceAction.deleteSelf)
        
        let predicate = NSPredicate(format: "character == %@", characterRef)
        
        let query = CKQuery(recordType: "PhysicsConfiguration", predicate: predicate)
        
        let configurePhysicsOperation = CKQueryOperation(query: query)
        
        configurePhysicsOperation.resultsLimit = 1
        
        
        
        configurePhysicsOperation.recordFetchedBlock = {
            
            record in
            
            let ckRecord = record
            
            
            guard let categoryBitMask = ckRecord.value(forKey: "categoryBitMask") as? Int64,
                let collisionBitMask = ckRecord.value(forKey: "collisionBitMask") as? Int64,
                let contactBitMask = ckRecord.value(forKey: "contactBitMask") as? Int64,
                let fieldBitMask = ckRecord.value(forKey: "fieldBitMask") as? Int64,
                let isDynamic = ckRecord.value(forKey: "isDynamic") as? Bool,
                let affectedByGravity = ckRecord.value(forKey: "affectedByGravity") as? Bool,
                let allowsRotation = ckRecord.value(forKey: "allowsRotation") as? Bool,
                let linearDamping = ckRecord.value(forKey: "linearDamping") as? Double,
                let angularDamping = ckRecord.value(forKey: "angularDamping") as? Double,
                let friction = ckRecord.value(forKey: "friction") as? Double,
                let restitution = ckRecord.value(forKey: "restitution") as? Double,
                let charge = ckRecord.value(forKey: "charge") as? Double,
                let mass = ckRecord.value(forKey: "mass") as? Double,
                let density = ckRecord.value(forKey: "density") as? Double,
                let angularVelocity = ckRecord.value(forKey: "angularVelocity") as? Double
                else {
                    return
            }
            
            var velocity: CGVector = CGVector.zero
            
            if let velocityStr = ckRecord.value(forKey: "velocity") as? String{
                velocity = CGVectorFromString(velocityStr)
            }
            
            let physicsConfiguration = PhysicsConfiguration(withCategoryBitmask: Int32(categoryBitMask), withCollisionBitMask: Int32(collisionBitMask), andWithContactBitMask: Int32(contactBitMask), withFieldBitMask: Int32(fieldBitMask), pAffectedByGravity: affectedByGravity, allowsRotation: allowsRotation, isDynamic: isDynamic, angularDamping: CGFloat(angularDamping), linearDamping: CGFloat(linearDamping), friction: CGFloat(friction), restitution: CGFloat(restitution), charge: CGFloat(charge), mass: CGFloat(mass), density: CGFloat(density), velocity: velocity, angularVelocity: CGFloat(angularVelocity))
            
            
            print("configuring physics properties for character")
            
            character.configurePhysicsBody(physicsConfiguration: physicsConfiguration)
            
            print("Finished configuring physics properties: \(character.node.physicsBody!)")
            
            
            
        }
        
        
        
        
        //Create an operation to configure the character's physics configuration
        
    
        configurePhysicsOperation.completionBlock = {
            
            
        
            completionHandler()
            
            
        }
        
        return configurePhysicsOperation
        
    }
    
}
