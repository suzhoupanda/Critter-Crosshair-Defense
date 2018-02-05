//
//  CritterCell.swift
//  Critter Crosshair Defense
//
//  Created by Aleksander Makedonski on 2/4/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class CritterCell: UICollectionViewCell{
    
    
    @IBOutlet weak var skView: SKView!
    
    var node: SKSpriteNode?
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}


class CharacterScene: SKScene{
    
    
    var characterNode: SKSpriteNode
    
    init(with characterNode: SKSpriteNode, size: CGSize){
        self.characterNode = characterNode
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        
    }
    
    
}
