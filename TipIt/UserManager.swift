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
    
    //var ud: NSUserDefaults?
    static let persistentPeriod = 100 * 60
    static let percentsKey = "percents"
    static let themeKey = "theme"
    static let lastBillKey = "lastBill"
    static let lastDateKey = "lastDate"
    var ud: NSUserDefaults?
    var percents: Percents?
    
    override init() {
        ud = NSUserDefaults.standardUserDefaults()
        percents = Percents(userDefault: ud!)
        super.init()
    }
    
    struct Percents {
        var defaults: NSUserDefaults?
        let count = 3
        init(userDefault: NSUserDefaults) {
            defaults = userDefault
        }
        subscript (i: Int) -> Double {
            get {
                if i >= 0 && i <= 2 {
                    if let percents = defaults?.objectForKey(UserManager.percentsKey) as? [Double] {
                        return percents[i]
                    } else {
                        // Initialize if the value is nil
                        let percents: [Double] = [0.1, 0.15, 0.2]
                        defaults?.setObject(percents, forKey: UserManager.percentsKey)
                        return percents[i]
                    }
                }
                return 0
            }
            set {
                if i >= 0 && i <= 2 {
                    if var percents = defaults?.objectForKey(UserManager.percentsKey) as? [Double] {
                        percents[i] = newValue
                        defaults!.setObject(percents, forKey: UserManager.percentsKey)
                    } else {
                        // Initialize if the value is nil
                        var percents: [Double] = [0.1, 0.15, 0.2]
                        percents[i] = newValue
                        defaults?.setObject(percents, forKey: UserManager.percentsKey)
                    }
                }
            }
        }
    }
    
    var theme: Bool? {
        get {
            if let theme = ud?.objectForKey(UserManager.themeKey) as? Bool {
                return theme
            } else {
                // Initialize if the value is nil
                let theme = false
                ud?.setObject(theme, forKey: UserManager.themeKey)
                return theme
            }
        }
        set {
            ud?.setObject(newValue, forKey: UserManager.themeKey)
        }
    }
    
    var lastDate: NSDate? {
        get {
            // Can return nil. No need to initialize
            return ud?.objectForKey(UserManager.lastDateKey) as? NSDate
        }
        set {
            ud?.setObject(newValue, forKey: UserManager.lastDateKey)
        }
    }

    var lastBill: Double? {
        get {
            // Can return nil. No need to initialize
            return ud?.objectForKey(UserManager.lastBillKey) as? Double
        }
        set {
            ud?.setObject(newValue, forKey: UserManager.lastBillKey)
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
                if (interval < UserManager.persistentPeriod) {
                    return true
                } else {
                    return false
                }
            }
            return false
        }
    }
}
