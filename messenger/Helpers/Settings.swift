//
//  Settings.swift
//  messenger
//
//  Created by Zarif Safiullin on 06/11/15.
//  Copyright © 2015 Zaph. All rights reserved.
//

import Foundation
import UIKit
import Hex


class Settings {
    
    static let sharedInstance = Settings()

    var backgroundColor: UIColor {
        get {
            let backgroundColorHex = NSUserDefaults.standardUserDefaults().stringForKey("settings.backgroundColor") ?? ""
            if backgroundColorHex != "" {
                return UIColor(hex: backgroundColorHex)
            } else {
                //TODO set green color
                return UIColor(hex: "#418C96")
            }
        }
        
        set {
            let backgroundColorHex = newValue.toHexString()
            NSUserDefaults.standardUserDefaults().setObject(backgroundColorHex, forKey: "settings.backgroundColor")
        }
    }
    
    var tintColor: UIColor {
        get {
            let tintColorHex = NSUserDefaults.standardUserDefaults().stringForKey("settings.tintColor") ?? ""
            if tintColorHex != "" {
                return UIColor(hex: tintColorHex)
            } else {
                return UIColor.whiteColor()
            }
        }
        
        set {
            let tintColorHex = newValue.toHexString()
            NSUserDefaults.standardUserDefaults().setObject(tintColorHex, forKey: "settings.tintColor")
        }

    }
    
    private init(){

    }
    
}

extension UIColor {

    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}