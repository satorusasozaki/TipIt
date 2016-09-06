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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        billField.addTarget(self, action: #selector(TipViewController.setupLabelTexts), forControlEvents: UIControlEvents.EditingChanged)
        billField.addTarget(self, action: #selector(TipViewController.animateViews), forControlEvents: UIControlEvents.EditingChanged)
        billField.addTarget(self, action: #selector(TipViewController.saveBill), forControlEvents: UIControlEvents.EditingDidEnd)
        percentControl.addTarget(self, action: #selector(TipViewController.setupLabelTexts), forControlEvents: UIControlEvents.ValueChanged)
        
        billField.text = "123"
        // Default setting
        user = UserManager()
        user?.percents = [0.1, 0.15, 0.20]
        user?.theme = false
        setupPercentControl()
        setupTheme()
        billField.placeholder = user?.currencySymbol
        setupLabelTexts()
        setupBillFieldTopConstraint()
        setupLabelsTopConstraint()
        
        if let isEmpty = billField.text?.isEmpty  {
            if isEmpty {
                labelsView.alpha = 0
            } else {
                labelsView.alpha = 1
            }
        }
        
        //billField.becomeFirstResponder()
        
        billFieldWasEmpty = billField.text?.isEmpty
        
    }
    
    // Calling updateTheme everytime when viewWillAppear gets called is inefficient
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    // MARK: Setups
    // Configure percent control with values from user default
    func setupPercentControl() {
        let percents = user?.percents
        for index in 0..<percents!.count {
            let percent = String(format: "%.0f", percents![index]*100)
            percentControl.setTitle("\(percent)%", forSegmentAtIndex: index)
        }
    }
    
    // Get theme state from user and set it
    func setupTheme() {
        if let themeState = user?.theme {
            if themeState {
                view.backgroundColor = UIColor.blackColor()
            } else {
                view.backgroundColor = UIColor.whiteColor()
            }
        }
    }
    
    // Set text in all the labels
    func setupLabelTexts() {
        let bill = Double(billField.text!) ?? 0
        let percent = user?.percents![percentControl.selectedSegmentIndex]
        let total = CalculatorBrain.getTotalAmount(bill, percent: percent!)
        let tip = CalculatorBrain.getTipAmount(bill, percent: percent!)
        tipLabel.text = (user?.currencySymbol)! + String(format: "%.2f", tip!)
        totalLabel.text = (user?.currencySymbol)! + String(format: "%.2f", total!)
        splitByTwoLabel.text = (user?.currencySymbol)! + String(format: "%.2f", CalculatorBrain.splitBy(total!, numOfPeople: 2)!)
        splitByThreeLabel.text = (user?.currencySymbol)! + String(format: "%.2f", CalculatorBrain.splitBy(total!, numOfPeople: 3)!)
    }
    
    // MARK: Constraint
    // Set labels top constraint depending on if bill is empty or not
    private func setupLabelsTopConstraint() {
        if ((billField.text?.isEmpty)!) {
            labelsViewTopConstraint.constant = 30
        } else {
            labelsViewTopConstraint.constant = 100
        }
    }
    
    // Set billField top constraint depending on if bill is empty or not
    func setupBillFieldTopConstraint() {
        if ((billField.text?.isEmpty)!) {
            billViewTopConstraint.constant = UIScreen.mainScreen().bounds.size.height / 3
        } else {
            billViewTopConstraint.constant = 0
        }
    }
    
    // MARK: Animation
    // Animate views if needed. Called every time bill field is changed
    func animateViews() {
        // research let if
        if (billFieldGetsEmpty()!) {
            setupBillFieldTopConstraint()
            setupLabelsTopConstraint()
            self.labelsView.alpha = 1
            UIView.animateWithDuration(0.4, animations: {
                self.labelsView.alpha = 0
                self.view.layoutIfNeeded()
            })
        } else if (billFieldGetsFilled()!){
            setupBillFieldTopConstraint()
            setupLabelsTopConstraint()
            self.labelsView.alpha = 0
            UIView.animateWithDuration(0.4, animations: {
                self.labelsView.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: Logic
    // When bill gets empty, returns true
    func billFieldGetsEmpty() -> Bool! {
        if (!billFieldWasEmpty! && billField.text!.isEmpty) {
            billFieldWasEmpty = true
            return true
        }
        return false
    }
    
    // When bill gets filled, returns true
    func billFieldGetsFilled() -> Bool! {
        if (billFieldWasEmpty! && !billField.text!.isEmpty) {
            billFieldWasEmpty = false
            return true
        }
        return false
    }
    
    // MARK: General
    // Save bill text to NSUserDefault when the editing is done
    func saveBill() {
        user?.lastBill = Double(billField.text!)
    }
    
    // To hide keyboard
    @IBAction func onTapTipViewController(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // Push setting view controller
    @IBAction func onSettingButton(sender: UIBarButtonItem) {
        print(#function)
        let settingTableViewController = storyboard?.instantiateViewControllerWithIdentifier("SettingTableViewController")
        navigationController?.pushViewController(settingTableViewController!, animated: true)
    }
}
