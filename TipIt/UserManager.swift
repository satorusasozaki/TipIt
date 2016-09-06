//
//  UserManager.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 8/30/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

// Make functions computed variable to make it simple
// Functions without parameter can likely be a computed variable

import UIKit

class UserManager: NSObject {
    
    var ud: NSUserDefaults?
    var percentsKey: String?
    var themeKey: String?
    var lastBillKey: String?
    var lastDateKey: String?
    
    var persistentPeriod: Int?
    
    override init() {
        ud = NSUserDefaults.standardUserDefaults()
        percentsKey = "percents"
        themeKey = "theme"
        lastBillKey = "lastBill"
        lastDateKey = "lastDate"
        persistentPeriod = 100 * 60
        super.init()
    }
    
    var percents: [Double]? {
        get {
            return ud?.objectForKey(percentsKey!) as? [Double]
        }
        set {
            newValue
        }
    }
    
    subscript (i: Int) -> Double? {
        get {
            return i >= 0 && i < 2 ? percents![i] : nil
        }
        set {
            if i >= 0 && i < 2 {
                percents![i] = newValue!
                ud?.setObject(percents, forKey: percentsKey!)
            }
        }
    }
    
    var theme: Bool? {
        get {
            return ud?.objectForKey(themeKey!) as? Bool
        }
        set {
            ud?.setObject(newValue, forKey: themeKey!)
        }
    }
    
    var lastDate: NSDate? {
        get {
            return ud?.objectForKey(lastDateKey!) as? NSDate
        }
        set {
            ud?.setObject(NSDate(), forKey: lastDateKey!)
        }
    }

    var lastBill: Double? {
        get {
            return ud?.objectForKey(lastBillKey!) as? Double
        }
        set {
            ud?.setObject(newValue, forKey: lastBillKey!)
        }
    }
    
    var currencySymbol: String? {
        get {
            let locale = NSLocale.currentLocale()
            let currencySymbol = locale.objectForKey(NSLocaleCurrencySymbol)!
            return currencySymbol as? String
        }
    }
    
    var shouldDisplayLastBill: Bool? {
        get {
            if let lastDate = lastDate {
                //http://stackoverflow.com/questions/11121459/how-to-convert-nstimeinterval-to-int
                let interval = NSInteger(NSDate().timeIntervalSinceDate(lastDate))
                if (interval < persistentPeriod) {
                    return true
                } else {
                    return false
                }
            }
            return false
        }
    }
}
