//
//  TipViewController.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 8/27/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class TipViewController: UIViewController{

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var splitByTwoLabel: UILabel!
    @IBOutlet weak var splitByThreeLabel: UILabel!
    @IBOutlet weak var percentControl: UISegmentedControl!
    
    @IBOutlet weak var billViewTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var labelsView: UIView!
    @IBOutlet weak var labelsViewTopConstraint: NSLayoutConstraint!
    
    var user: UserManager?
    var billFieldWasEmpty: Bool?
    
    // Calling updateTheme everytime when viewWillAppear gets called is inefficient
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
//        updateTheme()
//        redraw()
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        billField.addTarget(self, action: #selector(TipViewController.setupLabelTexts), forControlEvents: UIControlEvents.EditingChanged)
        billField.addTarget(self, action: #selector(TipViewController.animateViews), forControlEvents: UIControlEvents.EditingChanged)
        billField.addTarget(self, action: #selector(TipViewController.animateViews), forControlEvents: UIControlEvents.EditingChanged)
        percentControl.addTarget(self, action: #selector(TipViewController.setupLabelTexts), forControlEvents: UIControlEvents.ValueChanged)
        
        // Default setting
        user = UserManager()
        user?.setPercentAtIndex(0, value: 0.1)
        user?.setPercentAtIndex(1, value: 0.15)
        user?.setPercentAtIndex(2, value: 0.29)
        user?.setTheme(false)
        setupPercentControl()
        updateTheme()
        billField.placeholder = getCurrencySymbol()
        
        billViewTopConstraint.constant = getBillFieldTopConstraint()

        setupLabelsConstraint()
        
        if let isEmpty = billField.text?.isEmpty  {
            if isEmpty {
                labelsView.alpha = 0
            } else {
                labelsView.alpha = 1
            }
        }
        
        
        billFieldWasEmpty = billField.text?.isEmpty
        //billField.text = "test"
        billField.becomeFirstResponder()
        if let lastBillShouldDisplay = user?.shouldDisplayLastBill() {
            if lastBillShouldDisplay {
                let lastBill = user?.getLastBill()
                let lastBillInString = String(lastBill!)
                billField.text = lastBillInString
            }
        }
    }
    
    
    func animateViews() {
        print(#function)
        // research let if
        if (billFieldGetsEmpty()) {
            billViewTopConstraint.constant = getBillFieldTopConstraint()
            setupLabelsConstraint()
            self.labelsView.alpha = 1
            UIView.animateWithDuration(0.4, animations: {
                self.labelsView.alpha = 0
                self.view.layoutIfNeeded()
            })
        } else if (billFieldGetsFilled()){
            billViewTopConstraint.constant = getBillFieldTopConstraint()
            setupLabelsConstraint()
            self.labelsView.alpha = 0
            UIView.animateWithDuration(0.4, animations: {
                self.labelsView.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func shouldDisplayLabels() {
        if let isEmpty = billField.text?.isEmpty {
            if isEmpty {
                
            }
        }
    }
    
    func billFieldGetsEmpty() -> Bool {
        if (!billFieldWasEmpty! && billField.text!.isEmpty) {
            billFieldWasEmpty = true
            return true
        }
        return false
    }
    
    func billFieldGetsFilled() -> Bool {
        if (billFieldWasEmpty! && !billField.text!.isEmpty) {
            billFieldWasEmpty = false
            return true
        }
        return false
    }
    private func setupLabelsConstraint() {
        print(#function)
        if((billField.text?.isEmpty)!) {
            labelsViewTopConstraint.constant = 30
        } else {
            labelsViewTopConstraint.constant = 100
        }
    }
    
    private func getBillFieldTopConstraint() -> CGFloat{
        print(#function)
        if let isEmpty = billField.text?.isEmpty {
            if isEmpty {
                return UIScreen.mainScreen().bounds.size.height / 3
            }
        }
        return 0
    }
    

    @IBAction func onTapTipViewController(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        print(#function)
    }
    
    func updateTheme() {
        print(#function)
        if let themeState = user?.getTheme() {
            if themeState {
                view.backgroundColor = UIColor.blackColor()
            } else {
                view.backgroundColor = UIColor.whiteColor()
            }
        }
    }
    
    func setupLabelTexts() {
        print(#function)
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
        print(#function)
        let percent = user?.getPercents()[percentControl.selectedSegmentIndex]
        return percent!
    }
    
    private func setupPercentControl() {
        print(#function)
        let percents = user?.getPercents()
        for index in 0..<percents!.count {
            let percent = String(format: "%.0f", percents![index]*100)
            percentControl.setTitle("\(percent)%", forSegmentAtIndex: index)
        }
    }
    
    func getCurrencySymbol() -> String {
        print(#function)
        let locale = NSLocale.currentLocale()
        let currencySymbol = locale.objectForKey(NSLocaleCurrencySymbol)!
        return currencySymbol as! String
    }
    
    func redraw() {
        print(#function)
        setupLabelTexts()
        setupPercentControl()
    }
    
    @IBAction func onSettingButton(sender: UIBarButtonItem) {
        print(#function)
        let settingTableViewController = storyboard?.instantiateViewControllerWithIdentifier("SettingTableViewController")
        navigationController?.pushViewController(settingTableViewController!, animated: true)
    }
}
