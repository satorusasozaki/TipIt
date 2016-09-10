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
    private static let persistentPeriod = 10
    private static let percentsKey = "percents"
    private static let themeKey = "theme"
    private static let lastBillKey = "lastBill"
    private static let lastDateKey = "lastDate"
    
    // keys for records
    static let recordKey = "record"
    
    // For timestamp in record
    private var formatter: NSDateFormatter?
    private static let dateFormat = "MM/dd/yyyy"
    
    private var ud: NSUserDefaults?
    var percents: Percents?
    var records: Records?
    
    override init() {
        ud = NSUserDefaults.standardUserDefaults()
        // Instantiate Percents struct
        percents = Percents(ud: ud!)
        records = Records(ud: ud!)
        formatter = NSDateFormatter()
        formatter!.dateFormat = NSDateFormatter.dateFormatFromTemplate(UserManager.dateFormat, options: 0, locale: NSLocale.currentLocale())
        super.init()
    }
    
    // Percents struct represents a virtual array of percent values
    struct Percents {
        let ud: NSUserDefaults?
        let count = 3
        
        init(ud: NSUserDefaults) {
            self.ud = ud
        }
        
        // With this operator, a client can get a percent value at index by percents[0]
        subscript (i: Int) -> Double {
            get {
                if i >= 0 && i <= 2 {
                    if let percents = ud?.objectForKey(UserManager.percentsKey) as? [Double] {
                        return percents[i]
                    } else {
                        // Initialize if percents in NUD has not initialized yet and is nil
                        let percents: [Double] = [0.1, 0.15, 0.2]
                        ud?.setObject(percents, forKey: UserManager.percentsKey)
                        return percents[i]
                    }
                }
                return 0
            }
            
            set {
                if i >= 0 && i <= 2 {
                    if var percents = ud?.objectForKey(UserManager.percentsKey) as? [Double] {
                        percents[i] = newValue
                        ud!.setObject(percents, forKey: UserManager.percentsKey)
                    } else {
                        // Initialize if the value is nil
                        var percents: [Double] = [0.1, 0.15, 0.2]
                        percents[i] = newValue
                        ud?.setObject(percents, forKey: UserManager.percentsKey)
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
    
    // Wrapper
    struct Records {
        
        let ud: NSUserDefaults?
        var count: Int
        
        init(ud: NSUserDefaults) {
            self.ud = ud
            if let records = ud.objectForKey(UserManager.recordKey) {
                let records = records as! [[String:String]]
                count = records.count
            } else {
                count = 0
            }
        }
        
        subscript (i: Int) -> BillRecord {
            mutating get {
                if let records = ud?.objectForKey(UserManager.recordKey) {
                    let records = records as! [[String:String]]
                    count = records.count
                    return BillRecord(rawRecord: records[i])
                } else {
                    let records: [[String:String]] = []
                    count = records.count
                    ud?.setObject(records, forKey: UserManager.recordKey)
                    return BillRecord()
                }
            }
        }
        
    }
    
    // user.addnewrecord()
    // user.records
    
    // records.addnewrecords()
    
    // Make record a class
    // record = records[0]
    // record.getBill
    
    func addNewRecord(bill: String, tipPercent: String, total: String) {

        let date = formatter!.stringFromDate(NSDate())
        let record: [String:String] = [BillRecord.billRecordKey: bill,
                                       BillRecord.tipPercentRecordKey: tipPercent,
                                       BillRecord.totalRecordKey: total,
                                       BillRecord.dateRecordKey: date]
        var records = ud?.objectForKey(UserManager.recordKey) as! [[String:String]]
        records.append(record)
        ud?.setObject(records, forKey: UserManager.recordKey)
    }
}