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
        persistentPeriod = 10 * 60
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
    
    // Call this method after making sure if the last bill should be displayed in bill field callind shouldDisplayLastbill
    func getLastBillAndDate() -> (bill: Double?, date: NSDate?)? {
        let lastBill = getLastBill()
        let lastDate = ud?.objectForKey(lastDateKey!) as! NSDate
        return (lastBill, lastDate)
    }
    
    func getLastBill() -> Double {
        return ud?.objectForKey(lastBillKey!) as! Double
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
    
    func setLastBill(bill: Double) {
        ud?.setObject(bill, forKey: lastBillKey!)
        ud?.setObject(NSDate(), forKey: lastDateKey!)
        print("\(bill) and \(NSDate()) is set in \(#function)")
    }
    
    func shouldDisplayLastBill() -> Bool {
        let last = getLastBillAndDate()
        if let lastDate = last!.date {
            //http://stackoverflow.com/questions/11121459/how-to-convert-nstimeinterval-to-int
            let interval = NSInteger(NSDate().timeIntervalSinceDate(lastDate))
            if (interval < persistentPeriod) {
                return true
            } else {
                return false
            }
        }
        return true
    }
    

}
