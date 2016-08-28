//
//  TipViewController.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 8/27/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class TipViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var splitByTwoLabel: UILabel!
    @IBOutlet weak var splitByThreeLabel: UILabel!
    @IBOutlet weak var percentControl: UISegmentedControl!

    var ud: NSUserDefaults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        billField.delegate = self
        billField.addTarget(self, action: #selector(TipViewController.updateLabels), forControlEvents: UIControlEvents.EditingChanged)
        percentControl.addTarget(self, action: #selector(TipViewController.updateLabels), forControlEvents: UIControlEvents.ValueChanged)
        ud = NSUserDefaults.standardUserDefaults()
        
        // Default setting
        ud?.setObject([0.2, 0.15, 0.2], forKey: "percents")
        ud?.setObject(false, forKey: "theme")
        setupPercentControl()
        updateTheme()
        print(getCurrencySymbol())
        billField.placeholder = getCurrencySymbol()
    }

    @IBAction func onTapTipViewController(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func updateTheme() {
        let switchState = ud?.objectForKey("theme") as! Bool
        if (switchState) {
            view.backgroundColor = UIColor.blackColor()
        } else {
            view.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func updateLabels() {
        let bill = Double(billField.text!) ?? 0
        let percent = getTipPercent()
        let total = CalculatorBrain.getTotalAmount(bill, percent: percent)
        let tip = CalculatorBrain.getTipAmount(bill, percent: percent)
        tipLabel.text = getCurrencySymbol() + String(format: "%.2f", tip)
        totalLabel.text = getCurrencySymbol() + String(format: "%.2f", total)
        splitByTwoLabel.text = getCurrencySymbol() + String(format: "%.2f", CalculatorBrain.splitBy(total, numOfPeople: 2))
        splitByThreeLabel.text = getCurrencySymbol() + String(format: "%.2f", CalculatorBrain.splitBy(total, numOfPeople: 3))
    }
    
    private func getTipPercent() -> Double {
        let percent = ud?.objectForKey("percents")![percentControl.selectedSegmentIndex] as! Double
        return percent
    }
    
    private func setupPercentControl() {
        let percents = ud?.objectForKey("percents") as! [Double]
        for index in 0..<percents.count {
            let percent = String(format: "%.0f", percents[index]*100)
            percentControl.setTitle("\(percent)%", forSegmentAtIndex: index)
        }
    }
    
    func getCurrencySymbol() -> String {
        let locale = NSLocale.currentLocale()
        let currencySymbol = locale.objectForKey(NSLocaleCurrencySymbol)!
        return currencySymbol as! String
    }
    
    func redraw() {
        updateLabels()
        setupPercentControl()
    }
    
    @IBAction func onSettingButton(sender: UIBarButtonItem) {
        let settingTableViewController = storyboard?.instantiateViewControllerWithIdentifier("SettingTableViewController")
        navigationController?.pushViewController(settingTableViewController!, animated: true)
    }
}
