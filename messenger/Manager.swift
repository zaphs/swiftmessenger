//
//  Manager.swift
//  messenger
//
//  Created by Zarif Safiullin on 30/08/15.
//  Copyright (c) 2015 Zaph. All rights reserved.
//

import Foundation
import MagicalRecord

class Manager {
    
    static let sharedInstance = Manager()
    
    //TODO get user data
    var user: User!
    var opponent: User!
    var newMessageCount:Int
    var username: String {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("username") as? String ?? ""
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "username")
        }
    }
    var avatarUrl: String {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("avatarUrl") as? String ?? ""
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "avatarUrl")
        }
    }
    
    private init() {
        newMessageCount = 0
        
        user = User.MR_createEntity()
        user.userId = 1
        user.online = true
        user.avatarUrl = ""
        user.displayName = "Kevin Foster"

        opponent = User.MR_createEntity()
        opponent.userId = 2
        opponent.online = true
        opponent.avatarUrl = ""
        opponent.displayName = "Robert Downey, Jr."        
    }

}