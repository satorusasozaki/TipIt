//
//  TipViewController.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 8/27/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
// https://github.com/Vaberer/Font-Awesome-Swift

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
    
    // To set colors
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var splitByTwoView: UIView!
    @IBOutlet weak var splitByThreeView: UIView!
    @IBOutlet weak var splitByFourView: UIView!
    var user: UserManager?
    var billFieldWasEmpty: Bool?
    var color: ColorManager?
    
    // People's label
    // split by two
    @IBOutlet weak var firstPersonOfSplitByTwo: UILabel!
    @IBOutlet weak var secondPersonOfSplitByTwo: UILabel!
    // split by three
    @IBOutlet weak var firstPersonOfSplitByThree: UILabel!
    @IBOutlet weak var secondPersonOfSplitByThree: UILabel!
    @IBOutlet weak var thirdPersonOfSplitByThree: UILabel!
    // split by four
    @IBOutlet weak var firstPersonOfSplitByFour: UILabel!
    @IBOutlet weak var secondPersonOfSplitByFour: UILabel!
    @IBOutlet weak var thirdPersonOfSplitByFour: UILabel!
    @IBOutlet weak var fourthPersonOfSplitByFour: UILabel!
    
    
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
        billField.placeholder = user?.currencySymbol
        setupLabelTexts()
        setupBillFieldTopConstraint()
        
        if let isEmpty = billField.text?.isEmpty  {
            if isEmpty {
                labelsView.alpha = 0
            } else {
                labelsView.alpha = 1
            }
        }
        billFieldWasEmpty = billField.text?.isEmpty
        
        color = ColorManager(status: (user?.theme)!)
        setupTheme()
        setupPeopleLabels()
        
        // set up icon
        navigationItem.leftBarButtonItem?.FAIcon = FAType.FASave
        navigationItem.rightBarButtonItem?.FAIcon = FAType.FACog
        
    }
    @IBAction func onSaveButton(sender: UIBarButtonItem) {
        let bill = billField.text!.isEmpty ? user!.currencySymbol! + "0.00" : user!.currencySymbol! + billField.text!
        let tipPercent = percentControl.titleForSegmentAtIndex(percentControl.selectedSegmentIndex)!
        let total = totalLabel.text!
        user?.addNewRecord(bill, tipPercent: tipPercent, total: total)
        for record in user!.records! {
            print(record)
        }
        
        // Show alert 
        let alert = UIAlertController(title: "Saved", message: "\(bill) is saved to the history" , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        alert.view.tintColor = color?.mainColor
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    // FontAwesome
    func setupPeopleLabels() {
        firstPersonOfSplitByTwo.FAIcon = FAType.FAUser
        secondPersonOfSplitByTwo.FAIcon = FAType.FAUser
        firstPersonOfSplitByThree.FAIcon = FAType.FAUser
        secondPersonOfSplitByThree.FAIcon = FAType.FAUser
        thirdPersonOfSplitByThree.FAIcon = FAType.FAUser
        firstPersonOfSplitByFour.FAIcon = FAType.FAUser
        secondPersonOfSplitByFour.FAIcon = FAType.FAUser
        thirdPersonOfSplitByFour.FAIcon = FAType.FAUser
        fourthPersonOfSplitByFour.FAIcon = FAType.FAUser
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
        color?.colorStatus = user?.theme
        navigationController?.navigationBar.tintColor = color?.mainColor
        percentControl.tintColor = color?.mainColor
        tipView.backgroundColor = color?.mainColor
        totalView.backgroundColor = color?.totalColor
        splitByTwoView.backgroundColor = color?.splitByTwoColor
        splitByThreeView.backgroundColor = color?.splitByThreeColor
        splitByFourView.backgroundColor = color?.splitByFourColor
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
    // Set billField top constraint depending on if bill is empty or not
    func setupBillFieldTopConstraint() {
        billViewTopConstraint.constant = (billField.text?.isEmpty)! ? UIScreen.mainScreen().bounds.size.height / 4 : 0
    }
    
    // MARK: Animation
    // Animate views if needed. Called every time bill field is changed
    func animateViews() {
        // research let if
        if (billFieldGetsEmpty()!) {
            setupBillFieldTopConstraint()
            self.labelsView.alpha = 1
            UIView.animateWithDuration(0.4, animations: {
                self.labelsView.alpha = 0
                self.view.layoutIfNeeded()
            })
        } else if (billFieldGetsFilled()!){
            setupBillFieldTopConstraint()
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
