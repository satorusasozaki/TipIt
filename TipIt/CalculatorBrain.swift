//
//  CalculatorBrain.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 8/27/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class CalculatorBrain: NSObject {
    class func getTipAmount(bill: Double, percent: Double) -> Double {
        return bill * percent
    }
    
    class func getTotalAmount(bill: Double, percent: Double) -> Double {
        return bill + (bill * percent)
    }
    
    class func splitBy(total: Double, numOfPeople: Int) -> Double {
        return roundToTwo(total / Double(numOfPeople))
    }
    
    class func roundToTwo(num: Double) -> Double {
        return round(100 * num) / 100
    }
}
