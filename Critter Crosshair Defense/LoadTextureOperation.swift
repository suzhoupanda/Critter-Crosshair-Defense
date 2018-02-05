//
//  LoadTextureOperation.swift
//  Critter Crosshair Defense
//
//  Created by Aleksander Makedonski on 2/4/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation
import CloudKit
import SpriteKit

class CKTexture{
    var isDownloaded: Bool = false
    
    var record: CKRecord
    var texture: SKTexture?
    
    init(with record: CKRecord){
        self.record = record
    }
    
}

class LoadTextureOperation: Operation{
    
    
    var cloudKitTexture: CKTexture
    
    init(with cloudKitTexture: CKTexture){
        
        self.cloudKitTexture = cloudKitTexture
        
        super.init()
    }
    
    override func main() {
        
        if self.isCancelled{
            return
        }
        
        let ckRecord = self.cloudKitTexture.record
        
        if let asset = ckRecord.value(forKey: "texture") as? CKAsset,
            let imageData = NSData(contentsOf: asset.fileURL),
            let textureImage = UIImage(data: imageData as Data) {
            
            print("Images obtained: \(textureImage.debugDescription)")
            
            cloudKitTexture.texture = SKTexture(image: textureImage)
            cloudKitTexture.isDownloaded = true
        }
        
      
        
    }
}
