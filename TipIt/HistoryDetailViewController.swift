//
//  HistoryDetailViewController.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 9/8/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class HistoryDetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = UserManager()
        let record = user.records![index!]
        dateLabel.text = record[UserManager.dateRecordKey]
        billLabel.text = record[UserManager.billRecordKey]
        tipAmountLabel.text = record[UserManager.tipPercentRecordKey]
        totalAmountLabel.text = record[UserManager.totalRecordKey]
    }
}
