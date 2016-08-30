//
//  UserManager.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 8/30/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    
    
    // get theme -> bool
    // get percents -> [Double]
    var ud: NSUserDefaults?
    
    var percentsKey: String?
    var themeKey: String?
    
    override init() {
        ud = NSUserDefaults.standardUserDefaults()
        percentsKey = "percents"
        themeKey = "theme"
        super.init()
    }
    
    func getPercents() -> [Double] {
        return ud?.objectForKey(percentsKey!) as! [Double]
    }
    
    func getPercentAtIndex(index: Int) -> Double {
        let percents = getPercents()
        if (index >= 0 && index < 3) {
            return percents[index]
        } else {
            print("Index is out of range\n")
        }
        return percents[0]
    }
    
    func getTheme() -> Bool {
        return ud?.objectForKey(themeKey!) as! Bool
    }
    
    func setPercentAtIndex(index: Int, value: Double) -> Void {
        if (index >= 0 && index < 3) {
            var percents = getPercents()
            percents[index] = value
            ud?.setObject(percents, forKey: percentsKey!)
        } else {
            print("Index is out of range\n")
        }
    }
    
    func setTheme(dark: Bool) {
        ud?.setObject(dark, forKey: themeKey!)
    }

}
