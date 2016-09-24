//
//  UserManager.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 8/30/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

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
    private var formatter: DateFormatter?
    private static let dateFormat = "MM/dd/yyyy"
    
    private var ud: UserDefaults?
    var percents: Percents?
    var billRecords: BillRecords?
    
    override init() {
        ud = UserDefaults.standard
        // Instantiate Percents struct
        percents = Percents(ud: ud!)
        billRecords = BillRecords(ud: ud!)
        formatter = DateFormatter()
        formatter!.dateFormat = DateFormatter.dateFormat(fromTemplate: UserManager.dateFormat, options: 0, locale: NSLocale.current)
        super.init()
    }
    
    // Percents struct represents a virtual array of percent values
    struct Percents {
        let ud: UserDefaults?
        let count = 3
        
        init(ud: UserDefaults) {
            self.ud = ud
        }
        
        // With this operator, a client can get a percent value at index by percents[0]
        subscript (i: Int) -> Double {
            get {
                if i >= 0 && i <= 2 {
                    if let percents = ud?.object(forKey: UserManager.percentsKey) as? [Double] {
                        return percents[i]
                    } else {
                        // Initialize if percents in NUD has not initialized yet and is nil
                        let percents: [Double] = [0.1, 0.15, 0.2]
                        ud?.set(percents, forKey: UserManager.percentsKey)
                        return percents[i]
                    }
                }
                return 0
            }
            
            set {
                if i >= 0 && i <= 2 {
                    if var percents = ud?.object(forKey: UserManager.percentsKey) as? [Double] {
                        percents[i] = newValue
                        ud!.set(percents, forKey: UserManager.percentsKey)
                    } else {
                        // Initialize if the value is nil
                        var percents: [Double] = [0.1, 0.15, 0.2]
                        percents[i] = newValue
                        ud?.set(percents, forKey: UserManager.percentsKey)
                    }
                }
            }
        }
    }
    
    var theme: Bool? {
        get {
            if let theme = ud?.object(forKey: UserManager.themeKey) as? Bool {
                return theme
            } else {
                // Initialize if the value is nil
                let theme = false
                ud?.set(theme, forKey: UserManager.themeKey)
                return theme
            }
        }
        set {
            ud?.set(newValue, forKey: UserManager.themeKey)
        }
    }
    
    var lastDate: NSDate? {
        get {
            return ud?.object(forKey: UserManager.lastDateKey) as? NSDate
        }
        set {
            ud?.set(newValue, forKey: UserManager.lastDateKey)
        }
    }

    var lastBill: Double? {
        get {
            return ud?.object(forKey: UserManager.lastBillKey) as? Double
        }
        set {
            ud?.set(newValue, forKey: UserManager.lastBillKey)
        }
    }
    
    var currencySymbol: String? {
        get {
            let locale = NSLocale.current
            return locale.currencySymbol
        }
    }
    
    // Tells a client class (tip view controller) if it should display the last bill
    var shouldDisplayLastBill: Bool {
        get {
            if let lastDate = lastDate {
                //http://stackoverflow.com/questions/11121459/how-to-convert-nstimeinterval-to-int
                let interval = NSInteger(NSDate().timeIntervalSince(lastDate as Date))
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
    
    // Wrapper for a dictionary item of type [String : String] from an array [[String:String]] in NSUserDefault
    // Returns BillRecord with BillRecords[index]
    // Client class can get each value in BillRecord with billRecord.bill easily
    // This gives client classes least privilege of manipulating records
    // Clients cannot put random key values to get values from records with records[random]
    struct BillRecords {
        
        let ud: UserDefaults?
        var count: Int
        
        init(ud: UserDefaults) {
            self.ud = ud
            if let records = ud.object(forKey: UserManager.recordKey) {
                let records = records as! [[String:String]]
                count = records.count
            } else {
                count = 0
            }
        }
        
        subscript (i: Int) -> BillRecord {
            mutating get {
                if let records = ud?.object(forKey: UserManager.recordKey) {
                    let records = records as! [[String:String]]
                    count = records.count
                    return BillRecord(rawRecord: records[i])
                } else {
                    let records: [[String:String]] = []
                    count = records.count
                    ud?.set(records, forKey: UserManager.recordKey)
                    return BillRecord()
                }
            }
        }
    }
    
    func addNewRecord(bill: String, tipPercent: String, total: String) {

        let date = formatter!.string(from: NSDate() as Date)
        let record: [String:String] = [BillRecord.billRecordKey: bill,
                                       BillRecord.tipPercentRecordKey: tipPercent,
                                       BillRecord.totalRecordKey: total,
                                       BillRecord.dateRecordKey: date]
        if var records = ud?.object(forKey: UserManager.recordKey) as? [[String:String]] {
            records.append(record)
            ud?.set(records, forKey: UserManager.recordKey)
        } else {
            var records = [[String:String]]()
            records.append(record)
            ud?.set(records, forKey: UserManager.recordKey)
        }

    }
}
