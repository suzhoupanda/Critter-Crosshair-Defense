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

    @IBOutlet weak var skView: SKView!
    
    var baseScene: SKScene!
    
    required init?(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)
    }
    
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        
        baseScene = BaseScene(size: UIScreen.main.bounds.size)
        
        self.skView.presentScene(baseScene)
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


