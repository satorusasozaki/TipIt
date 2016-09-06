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
    
    func getPercents() -> [Double]? {
        return ud?.objectForKey(percentsKey!) as? [Double]
    }
    
    func getPercentAtIndex(index: Int) -> Double? {
        if (index >= 0 && index < 3) {
            if let percents = getPercents() {
                return percents[index]
            } else {
                return nil
            }
        }
        return nil
    }
    
    func getTheme() -> Bool? {
        return ud?.objectForKey(themeKey!) as? Bool
    }
    
    func getLastDate() -> NSDate? {
        return ud?.objectForKey(lastDateKey!) as? NSDate
    }
    
    func getLastBill() -> Double? {
        return ud?.objectForKey(lastBillKey!) as? Double
    }
    
    func setPercentAtIndex(index: Int, value: Double) {
        if (index >= 0 && index < 3) {
            if var percents = getPercents() {
                percents[index] = value
                ud?.setObject(percents, forKey: percentsKey!)
            } else {
                var percents:[Double] = [0, 0, 0]
                percents[index] = value
                ud?.setObject(percents, forKey: percentsKey!)
            }
        }  
    }
    
    func setTheme(dark: Bool) {
        ud?.setObject(dark, forKey: themeKey!)
    }
    
    func setLastBill(bill: Double) {
        ud?.setObject(bill, forKey: lastBillKey!)
        ud?.setObject(NSDate(), forKey: lastDateKey!)
        print("\(bill) and \(NSDate()) is set in \(#function)")
    }
    
    func shouldDisplayLastBill() -> Bool {
        if let lastDate = getLastDate() {
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
    
    // Get the currency symbol based on location
    func getCurrencySymbol() -> String {
        let locale = NSLocale.currentLocale()
        let currencySymbol = locale.objectForKey(NSLocaleCurrencySymbol)!
        return currencySymbol as! String
    }
    

}
