//
//  ViewController.swift
//  Critter Crosshair Defense
//
//  Created by Aleksander Makedonski on 2/4/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import UIKit
import SpriteKit
import CloudKit

class ViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var backgroundQueue: OperationQueue
    var characterRecords: [CKRecord]
    
    required init?(coder aDecoder: NSCoder) {
        backgroundQueue = OperationQueue()
        characterRecords = []
        super.init(coder: aDecoder)
    }
    
    /**
     
     Alien Location
     
         CLLocation - location coordinate
             - use the coordinate to load a background image based on a satellite image
             -
     
     Character
         name
         health
         position
     
         CKAsset - default texture
         CKReference -
             Physics Configuration
             Animation
                 RepeatedAnimation
                 IntervalAnimation
 
     **/
    
    let container = CKContainer.default()
    
    var publicDB: CKDatabase{
        return container.publicCloudDatabase
    }
    
    var privateDB: CKDatabase{
        return container.privateCloudDatabase
    }
    
    var sharedDB: CKDatabase{
        return container.sharedCloudDatabase
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       let characterManager = CharacterManager()
        
        characterManager.loadCharacters()
        
        /**
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "CharacterABC", predicate: predicate)
        
        self.publicDB.perform(query, inZoneWith: nil){
            results, error in
            
            if(error != nil){
                print("Error occurred whil trying to connect to CloudKit")
                print(error!.localizedDescription)
                print(error.debugDescription)
                
            } else {
                if let records = results{
                    print(records.description)

                } else {
                    print("Obtained nil value for records")
                }
            }
            
        }
         **/
        
    
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return characterRecords.count
    
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CritterThumbnail", for: indexPath) as! CritterThumbnail
        
        let ckRecord = characterRecords[indexPath.row]
        
        weak var weakCell = cell
        
        backgroundQueue.addOperation {
        
            
            if let ckAsset = ckRecord.object(forKey: "texture") as? CKAsset{
                
                let url = ckAsset.fileURL
                
                if let imageData = NSData(contentsOf: url){
                    
                    OperationQueue.main.addOperation {
                        weakCell?.imageView.image = UIImage(data: imageData as Data)
                    }
                    
                }
                    
               
                
            }
        }
        
        
        return cell
    }
}



extension ViewController: UICollectionViewDelegate{
    
    
    
}

