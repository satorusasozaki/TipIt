//
//  BillRecord.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 9/10/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class BillRecord: NSObject {
    // keys
    static let billRecordKey = "billRecord"
    static let tipPercentRecordKey = "tipPercentRecord"
    static let totalRecordKey = "totalRecord"
    static let dateRecordKey = "dateRecord"
    
    let bill: String?
    let tipPercent: String?
    let total: String?
    let date: String?
    
    override init() {
        bill = ""
        tipPercent = ""
        total = ""
        date = ""
        super.init()
    }
    
    // init with an item from [[String:String]]
    init(rawRecord: [String:String]) {
        self.bill = rawRecord[BillRecord.billRecordKey]
        self.tipPercent = rawRecord[BillRecord.tipPercentRecordKey]
        self.total = rawRecord[BillRecord.totalRecordKey]
        self.date = rawRecord[BillRecord.dateRecordKey]
    }
}
