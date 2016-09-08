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
    @IBOutlet weak var splitByFourLabel: UILabel!
    @IBOutlet weak var percentControl: UISegmentedControl!
    @IBOutlet weak var billViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelsView: UIView!
    @IBOutlet weak var labelsViewTopConstraint: NSLayoutConstraint!
    
    
    var user: UserManager?
    var billFieldWasEmpty: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add target
        billField.addTarget(self, action: #selector(TipViewController.setupLabelTexts), forControlEvents: UIControlEvents.EditingChanged)
        billField.addTarget(self, action: #selector(TipViewController.animateViews), forControlEvents: UIControlEvents.EditingChanged)
        billField.addTarget(self, action: #selector(TipViewController.saveBill), forControlEvents: UIControlEvents.EditingDidEnd)
        percentControl.addTarget(self, action: #selector(TipViewController.setupLabelTexts), forControlEvents: UIControlEvents.ValueChanged)
        // Make bill field the first responder
        billField.performSelector(#selector(UIResponder.becomeFirstResponder), withObject: nil, afterDelay: 0.5)

        user = UserManager()
        // billField.becomeFirstResponder() won't work
        // billField text disappears when the keyboard gets toggle as the first responder
        if let lastBill = user?.lastBill {
            billField.text = (user?.shouldDisplayLastBill)! ? String(lastBill) : ""
        }
        //billField.text = (user?.shouldDisplayLastBill)! ? String((user?.lastBill)!) : ""

        // Default setting
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
        billFieldWasEmpty = billField.text?.isEmpty
    }
    
    // I thought calling updateTheme everytime when viewWillAppear gets called is inefficient
    // updateTheme method is called when the theme switch has been changed in setting view controleller
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: Setups
    // Configure percent control with values from user default
    func setupPercentControl() {
        let percents = user?.percents!
        for index in 0..<percents!.count {
            let percent = String(format: "%.0f", percents![index]*100)
            percentControl.setTitle("\(percent)%", forSegmentAtIndex: index)
        }
    }
    
    // Get theme state from user and set it
    func setupTheme() {
        if let themeState = user?.theme {
            view.backgroundColor = themeState ? UIColor.blackColor() : UIColor.whiteColor()
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
        splitByFourLabel.text = (user?.currencySymbol)! + String(format: "%.2f", CalculatorBrain.splitBy(total!, numOfPeople: 4)!)
    }
    
    // MARK: Constraint
    // Set labels top constraint depending on if bill is empty or not
    private func setupLabelsTopConstraint() {
        //labelsViewTopConstraint.constant = (billField.text?.isEmpty)! ? 30 : 30
    }
    
    // Set billField top constraint depending on if bill is empty or not
    func setupBillFieldTopConstraint() {
        billViewTopConstraint.constant = (billField.text?.isEmpty)! ? UIScreen.mainScreen().bounds.size.height / 3 : 0
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
        user?.lastDate = NSDate()
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
