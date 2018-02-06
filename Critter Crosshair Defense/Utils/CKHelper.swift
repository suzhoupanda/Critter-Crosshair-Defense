//
//  CKHelper.swift
//  Critter Crosshair Defense
//
//  Created by Aleksander Makedonski on 2/4/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation
import CloudKit


class CKHelper{
    
    static let sharedHelper = CKHelper()

    let container: CKContainer = CKContainer.default()
    
    var publicDB: CKDatabase
    var privateDB: CKDatabase
    var sharedDB: CKDatabase
    
    
    private init(){
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        sharedDB = container.sharedCloudDatabase
    }
    
}
