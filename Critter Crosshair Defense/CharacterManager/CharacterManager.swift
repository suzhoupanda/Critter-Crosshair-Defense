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
    
    /** Stored Properties **/
    
    private var publicDB = CKHelper.sharedHelper.publicDB
    private var backgroundQueue = OperationQueue()
    
    private var characterDict = [String:Character]()
    private var tConfigurations = [TextureConfiguration]()
    private var animationTextures = [CKRecord]()
    
    weak var delegate: CharacterManagerDelegate?
    /** A computed property for the CKQuery that is used to initialize a CKQueryOperation that is responsible for loading all of the characters from the public database **/

    
    lazy private var allCharactersQuery: CKQuery = {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "CharacterABC", predicate: predicate)
        
        return query
        
    }()
    
    
    /** A computed property for the CKQuery that is used to initialize a CKQueryOperation that is responsible for loading all of the textures from database **/
    
    lazy private var allTexturesQuery: CKQuery = {
       
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "AnimationTextureABC", predicate: predicate)
        
        return query
    }()
    
    
    func loadGameObjects(){
        
        let LoadAnimationTextureOperation = configureLoadAnimationTexturesOperation(withCompletionHandler: {
            print("Finished downloading all the animation textures.")
            self.delegate?.didLoadTextureConfigurations()
        })
        
        
        let LoadCharacterOperation = configureLoadCharactersOperation(withCompletionHandler: {
            
            
            self.configureWingmanAnimations()
            self.configureSpikeballAnimations()
            self.configureSunAnimations()
            
            self.configureFlymanAnimations()
            self.configureSpikemanAnimations()
            
            self.showCharacterAnimationsDebugInfo()
            
        })
        
        
        LoadCharacterOperation.addDependency(LoadAnimationTextureOperation)
        
        self.publicDB.add(LoadAnimationTextureOperation)
        self.publicDB.add(LoadCharacterOperation)
        
    }
    
    /** Creates, configures, and returns a CKQueryOperation that will download all of the textures from the public database and convert them to TextureConfigruation objects **/
    
    func loadAnimationTextures(){
        
        let LoadAnimationTextureOperation = configureLoadAnimationTexturesOperation(withCompletionHandler: {
        })
        
        self.publicDB.add(LoadAnimationTextureOperation)
    }
    
    func loadCharacters(){
        
        let LoadCharacterOperation = configureLoadCharactersOperation(withCompletionHandler: {
            
        
            
            self.showCharacterAnimationsDebugInfo()
            
        })
        
        self.publicDB.add(LoadCharacterOperation)
    }
    
    
    private func showCharacterAnimationsDebugInfo(){
        if let wingman = self.characterDict["wingman"]{
            let debugStr = wingman.getAnimationsDictDebugString()
            print("Wingman Animations Info: \(debugStr)")
            
        }
        
        if let spikeball = self.characterDict["spikeball"]{
            let debugStr = spikeball.getAnimationsDictDebugString()
            print("Spikeball Animations Info: \(debugStr)")
            
        }
        
        if let sun = self.characterDict["sun"]{
            let debugStr = sun.getAnimationsDictDebugString()
            print("Sun Animations Info: \(debugStr)")
            
        }
        
        
        if let spikeman = self.characterDict["spikeman"]{
            let debugStr = spikeman.getAnimationsDictDebugString()
            print("Spikeman Animations Info: \(debugStr)")
            
        }
        
        if let flyman = self.characterDict["flyman"]{
            let debugStr = flyman.getAnimationsDictDebugString()
            print("Spikeman Animations Info: \(debugStr)")
            
        }
    }
    
    private func configureSpikemanAnimations(){
        
        let tConfigurationManager = TextureConfigurationManager(withTextureConfigurations: self.tConfigurations)
        
        if let spikeman = self.characterDict["spikeman"]{
            
            let spikemanTextureAnimationsGenerator = tConfigurationManager.getTextureAnimation(forTextureAnimationWith: "spikemanWalkRight", andOrientation: .Right, andTimePerFrame: 0.40)
            
            
            spikeman.configureAnimations(with: spikemanTextureAnimationsGenerator)
            self.delegate?.didConfigureTextureAnimationFor(spikeman)
            
        }
        
    }
    
    private func configureWingmanAnimations(){
        
        let tConfigurationManager = TextureConfigurationManager(withTextureConfigurations: self.tConfigurations)
        
        if let wingman = self.characterDict["wingman"]{
            
            let wingmanTextureAnimationsGenerator = tConfigurationManager.getTextureAnimation(forTextureAnimationWith: "wingmanFly", andOrientation: .None, andTimePerFrame: 0.40)
            
            
            wingman.configureAnimations(with: wingmanTextureAnimationsGenerator)
            self.delegate?.didConfigureTextureAnimationFor(wingman)
        
        }
        
    }
    
    
    private func configureFlymanAnimations(){
        
        let tConfigurationManager = TextureConfigurationManager(withTextureConfigurations: self.tConfigurations)
        
        if let flyman = self.characterDict["flyman"]{
            
            let flymanTextureAnimationsGenerator = tConfigurationManager.getTextureAnimation(forTextureAnimationWith: "flymanFly", andOrientation: .None, andTimePerFrame: 0.40)
            
            
            flyman.configureAnimations(with: flymanTextureAnimationsGenerator)
            self.delegate?.didConfigureTextureAnimationFor(flyman)
            
        }
        
    }
    
    
    private func configureSunAnimations(){
        
        let tConfigurationManager = TextureConfigurationManager(withTextureConfigurations: self.tConfigurations)
        
        if let sun = self.characterDict["sun"]{
            
            let sunTextureAnimationsGenerator = tConfigurationManager.getTextureAnimation(forTextureAnimationWith: "sunRotate", andOrientation: .None, andTimePerFrame: 0.40)
            
            
            sun.configureAnimations(with: sunTextureAnimationsGenerator)
            self.delegate?.didConfigureTextureAnimationFor(sun)
            
        }

        
    }
    
    private func configureSpikeballAnimations(){
        
        let tConfigurationManager = TextureConfigurationManager(withTextureConfigurations: self.tConfigurations)
        
        if let spikeball = self.characterDict["spikeball"]{
            
            let spikeballTextureAnimationsGenerator = tConfigurationManager.getTextureAnimation(forTextureAnimationWith: "spikeballRotate", andOrientation: .None, andTimePerFrame: 0.40)
            
            
            
            spikeball.configureAnimations(with: spikeballTextureAnimationsGenerator)
            self.delegate?.didConfigureTextureAnimationFor(spikeball)
        }
        
    }
    
    private func configureLoadAnimationTexturesOperation(withCompletionHandler completionHandler: (()->(Void))?) -> CKQueryOperation{
        
        let ckQueryOperation = CKQueryOperation(query: self.allTexturesQuery)
        
        ckQueryOperation.recordFetchedBlock = {
            
            record in
            
            
            if let tConfiguration = self.getTextureConfiguration(fromRecord: record){
                self.tConfigurations.append(tConfiguration)
            }
           
            
        }
        
        ckQueryOperation.completionBlock = {
            print("Texture have been loaded. A total of \(self.tConfigurations.count) have been loaded")
            if let completionHandler = completionHandler{
                completionHandler()
            }
        }
        
        return ckQueryOperation
    }
    
  
   
    
    
    private func configureLoadCharactersOperation(withCompletionHandler completionHandler: (()->(Void))?) -> CKQueryOperation{
        
        let ckOperation = CKQueryOperation(query: self.allCharactersQuery)
        
        ckOperation.recordFetchedBlock = {
            
            record in
            
            if let character = self.getCharacter(fromRecord: record){
                
                
                self.characterDict[character.name] = character
                
                let LoadCharacterPhysicsOperation = self.configureLoadCharacterPhysicsOperation(forCharacter: character, andCKRecord: record, andCompletionHandler: {
                    
                    self.delegate?.didConfigurePhysicsFor(character)
                })
                

                LoadCharacterPhysicsOperation.addDependency(ckOperation)
                
                self.publicDB.add(LoadCharacterPhysicsOperation)
            }
            
        }
        
        ckOperation.completionBlock = {
            
            
            if let completionHandler = completionHandler{
                completionHandler()
            }
        }
        
        return ckOperation
    }
    
    func loadCharactersOnBackgroundQueue(){
        
        print("Preparing to load characters....")

        self.publicDB.perform(self.allCharactersQuery, inZoneWith: nil){
            
            records, error in
            
            if(error != nil){
                
                print(error!.localizedDescription)
                
            } else {
                
                if let ckRecords = records, ckRecords.count > 0{
                    
                    ckRecords.forEach({
                        
                        self.loadCharacterOnBackgoundQueue(from: $0)
                        
                    })
                }
            }
            
            
        }
    }
    
    func loadCharacterOnBackgoundQueue(from ckRecord: CKRecord){
        
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
            
            self.characterDict[character.name] = character
            print("Finished loading the texture")
        }
        
    

        //Add operations to the background queue
        backgroundQueue.addOperation(loadTextureOperation)
       
        
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
            
            let scaleAnimationGenerator = ScaleAnimationGenerator(animationName: animationName, xScaleTo: xScaleTo, yScaleTo: yScaleTo, xScaleBy: xScaleBy, yScaleBy: yScaleBy, duration: duration)



            character.configureAnimations(with: scaleAnimationGenerator)

            
        }
        
        
        ckQueryOperation.completionBlock = {
            
            completionHandler()
        }
        
        return ckQueryOperation
    }
    
    
    func createConfigureMoveAnimationsOperation(forCharacter character: Character, andCKRecord ckRecord: CKRecord, andCompletionHandler completionHandler: @escaping ()->(Void)) -> CKQueryOperation{
        
        
        let recordID = ckRecord.recordID
        
        let ckReference = CKReference(recordID: recordID, action: CKReferenceAction.deleteSelf)
        
        let predicate = NSPredicate(format: "characterABC == %@", ckReference)
        
        let query = CKQuery(recordType: "MoveAnimationABC", predicate: predicate)
        
        
        let ckQueryOperation = CKQueryOperation(query: query)
        
        ckQueryOperation.resultsLimit = 1
        
        ckQueryOperation.recordFetchedBlock = {
            
            record in
            
            print("Processing record for move animation query - currently processing record: \(record)")
            
            guard let duration = record.value(forKey: "duration") as? Double, let animationName = record.value(forKey: "animationName") as? String else {
                    return
            }
            
            let xMoveBy = record.value(forKey: "xMoveBy") as? Double
            let xMoveTo = record.value(forKey: "xMoveTo") as? Double
            let yMoveBy = record.value(forKey: "yMoveBy") as? Double
            let yMoveTo = record.value(forKey: "yMoveTo") as? Double

            let moveAnimationGenerator = MoveAnimationGenerator(animationName: animationName, xMoveTo: xMoveTo, yMoveTo: yMoveTo, xMoveBy: xMoveBy, yMoveBy: yMoveBy, duration: duration)

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
            
            let rotateAnimationGenerator = RotateAnimationGenerator(animationName: animationName, rotateTo: rotateToAngle, rotateBy: rotateByAngle, shortestUnitArc: true, duration: duration)
            
            character.configureAnimations(with: rotateAnimationGenerator)
        }
        
        ckQueryOperation.completionBlock = {
            
            completionHandler()
        }
        
        return ckQueryOperation
        
        
    }
    
   
    func configureLoadCharacterPhysicsOperation(forCharacter character: Character, andCKRecord ckRecord: CKRecord, andCompletionHandler completionHandler: @escaping ()->(Void)) -> CKQueryOperation{
        
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
            
            
            
            character.configurePhysicsBody(physicsConfiguration: physicsConfiguration)
            
            
            
            
        }
        
        
        
        
        //Create an operation to configure the character's physics configuration
        
    
        configurePhysicsOperation.completionBlock = {
            
            
        
            completionHandler()
            
            
        }
        
        return configurePhysicsOperation
        
    }
    
    
    /** Helper methods for converting CKRecord to TextureConfiguration object **/
    
    func getCharacter(fromRecord ckRecord: CKRecord) -> Character?{
        
        guard let anchorPointStr = ckRecord.value(forKey: "anchorPoint") as? String,
            let zPosition = ckRecord.value(forKey: "zPosition") as? Double,
            let xScale = ckRecord.value(forKey: "xScale") as? Double,
            let yScale = ckRecord.value(forKey: "yScale") as? Double,
            let charName = ckRecord.value(forKey: "name") as? String else {
                return nil
        }
        
        guard let texture = getTexture(fromCKRecord: ckRecord) else {
            return nil
        }
        
        let anchorPoint = CGPointFromString(anchorPointStr)
        
        let character = Character(name: charName, anchorPoint: anchorPoint, zPosition: CGFloat(zPosition), xScale: CGFloat(xScale), yScale: CGFloat(yScale))
        
        character.configureTexture(with: texture)
        
        return character
    }
    
    
    func getTextureConfiguration(fromRecord ckRecord: CKRecord) -> TextureConfiguration?{
        
        guard let order = ckRecord.value(forKey: "order") as? Int64,
            let name = ckRecord.value(forKey: "animationName") as? String else { return nil }
        
        guard  let orientationRawValue = ckRecord.value(forKey: "orientation") as? Int64,
        let orientation = Orientation(rawValue: orientationRawValue) else { return nil }
        

        let texture = getTexture(fromCKRecord: ckRecord)
        
       
        return TextureConfiguration(name: name, texture: texture, order: Int(order), orientation: orientation)
        
    }
    
    func getTexture(fromCKRecord ckRecord: CKRecord) -> SKTexture?{
        
        guard let asset = ckRecord.value(forKey: "texture") as? CKAsset,let imageData = NSData(contentsOf: asset.fileURL),let image = UIImage(data: imageData as Data) else {
            
            return nil
          }
        
        return SKTexture(image: image)
    }
    
}
