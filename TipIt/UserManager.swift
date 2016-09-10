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
    private static let persistentPeriod = 2
    private static let percentsKey = "percents"
    private static let themeKey = "theme"
    private static let lastBillKey = "lastBill"
    private static let lastDateKey = "lastDate"
    
    // keys for records
    static let recordKey = "record"
    static let billRecordKey = "billRecord"
    static let tipPercentRecordKey = "tipPercentRecord"
    static let totalRecordKey = "totalRecord"
    static let dateRecordKey = "dateRecord"
    
    // For timestamp in record
    private var formatter: NSDateFormatter?
    private static let dateFormat = "MM/dd/yyyy"
    
    private var ud: NSUserDefaults?
    var percents: Percents?
    
    override init() {
        ud = NSUserDefaults.standardUserDefaults()
        percents = Percents(userDefault: ud!)
        formatter = NSDateFormatter()
        let template = NSDateFormatter.dateFormatFromTemplate(UserManager.dateFormat, options: 0, locale: NSLocale.currentLocale())
        
        formatter!.dateFormat = template
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
            return ud?.objectForKey(UserManager.lastDateKey) as? NSDate
        }
        set {
            ud?.setObject(newValue, forKey: UserManager.lastDateKey)
        }
    }

    var lastBill: Double? {
        get {
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
    
    // Tells a client class (tip view controller) if it should display the last bill
    var shouldDisplayLastBill: Bool {
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
    
    // MARK: - Records
    var records: [[String:String]]? {
        get {
            if let r = ud?.objectForKey(UserManager.recordKey) {
                return r as? [[String : String]]
            } else {
                let dictionaries = [[String:String]]()
                ud?.setObject(dictionaries, forKey: UserManager.recordKey)
                return dictionaries
            }
        }
        set {
        }
    }
    
    func addNewRecord(bill: String, tipPercent: String, total: String) {

        let date = formatter!.stringFromDate(NSDate())
        let record: [String:String] = [UserManager.billRecordKey: bill,
                                       UserManager.tipPercentRecordKey: tipPercent,
                                       UserManager.totalRecordKey: total,
                                       UserManager.dateRecordKey: date]
        var r = records
        r?.append(record)
        ud?.setObject(r, forKey: UserManager.recordKey)
    }
}











