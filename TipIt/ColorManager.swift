//
//  ColorManager.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 9/7/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import Foundation
import UIColor_Hex_Swift
//https://github.com/yeahdongcn/UIColor-Hex-Swift

class ColorManager: NSObject {
    var colorStatus: Bool?
    
    init(status: Bool) {
        super.init()
        colorStatus = status
    }
    
    private static let general = "general"
    private static let total = "total"
    private static let splitByTwo = "splitByTwo"
    private static let splitByThree = "splitByThree"
    private static let splitByFour = "splitByFour"
    
    private static let green: [String:String] = [general: "219965",
                                          total: "25ae73",
                                          splitByTwo: "2ac381",
                                          splitByThree: "33d38e",
                                          splitByFour: "48d89a"]
    private static let yellow: [String:String] = [general: "b69105",
                                         total: "cfa505",
                                         splitByTwo: "e8b906",
                                         splitByThree: "f9c80e",
                                         splitByFour: "face27"]
    
    var mainColor: UIColor {
        get {
            return colorStatus! ? UIColor(rgba: ColorManager.green[ColorManager.general]!) : UIColor(rgba: ColorManager.yellow[ColorManager.general]!)
        }
    }

    var totalColor: UIColor {
        get {
            return colorStatus! ? UIColor(rgba: ColorManager.green[ColorManager.total]!) : UIColor(rgba: ColorManager.yellow[ColorManager.total]!)
        }
    }
    
    var splitByTwoColor: UIColor {
        get {
            return colorStatus! ? UIColor(rgba: ColorManager.green[ColorManager.splitByTwo]!) : UIColor(rgba: ColorManager.yellow[ColorManager.splitByTwo]!)
        }
    }
    
    var splitByThreeColor: UIColor {
        get {
            return colorStatus! ? UIColor(rgba: ColorManager.green[ColorManager.splitByThree]!) : UIColor(rgba: ColorManager.yellow[ColorManager.splitByThree]!)
        }
    }
    
    var splitByFourColor: UIColor {
        get {
            return colorStatus! ? UIColor(rgba: ColorManager.green[ColorManager.splitByFour]!) : UIColor(rgba: ColorManager.yellow[ColorManager.splitByFour]!)
        }
    }
}