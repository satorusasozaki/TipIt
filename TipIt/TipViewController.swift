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
    private var user: UserManager?
    private var billFieldWasEmpty: Bool?
    private var color: ColorManager?
    
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
        
        // Add actions to views
        billField.addTarget(self, action: #selector(TipViewController.setupLabelTexts), forControlEvents: UIControlEvents.EditingChanged)
        billField.addTarget(self, action: #selector(TipViewController.animateViews), forControlEvents: UIControlEvents.EditingChanged)
        percentControl.addTarget(self, action: #selector(TipViewController.setupLabelTexts), forControlEvents: UIControlEvents.ValueChanged)

        // Create managers
        user = UserManager()
        color = ColorManager(status: (user?.theme)!)
        
        // Initial view setups
        setupPercentControl()
        setupLabelTexts()
        setupBillFieldTopConstraint()
        setupTheme()
        setupSplitIcons()
        labelsView.alpha = 0
        
        // Set up bill field
        billField.becomeFirstResponder()
        billField.placeholder = user?.currencySymbol
        billFieldWasEmpty = billField.text?.isEmpty
        
        // set up icon
        navigationItem.leftBarButtonItem?.FAIcon = FAType.FASave
        navigationItem.rightBarButtonItem?.FAIcon = FAType.FACog
        
        // add observer to determine whether to set lastBill to billField when applicationDidBecomeActive
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onResume), name: UIApplicationDidBecomeActiveNotification, object: nil)
        // add observer to save the last bill and its date to NSUserDefault
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onSuspend), name: UIApplicationWillResignActiveNotification, object: nil)
        
    }
    
    // MARK: View setups
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
    
    // FontAwesome
    func setupSplitIcons() {
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
    
    // MARK: - Outlet Action
    
    // To hide keyboard
    @IBAction func onTapTipViewController(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // Push to setting view controller
    @IBAction func onSettingButton(sender: UIBarButtonItem) {
        let settingTableViewController = storyboard?.instantiateViewControllerWithIdentifier("SettingTableViewController")
        navigationController?.pushViewController(settingTableViewController!, animated: true)
    }
    
    @IBAction func onSaveButton(sender: UIBarButtonItem) {
        // Get values needed from views and commit them to user
        let bill = billField.text!.isEmpty ? user!.currencySymbol! + "0.00" : user!.currencySymbol! + billField.text!
        let tipPercent = percentControl.titleForSegmentAtIndex(percentControl.selectedSegmentIndex)!
        let total = totalLabel.text!
        user?.addNewRecord(bill, tipPercent: tipPercent, total: total)

        // Show alert
        let alert = UIAlertController(title: "Saved", message: "\(bill) is saved to the history" , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        alert.view.tintColor = color?.mainColor
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    // MARK: - Methods Pluged into App Lifecycle
    
    // Called when applicationWillResignActiveNotification by notification center
    func onSuspend() {
        user?.lastBill = Double(billField.text!)
        user?.lastDate = NSDate()
    }
    
    // Called when applicationDidBecomeActive by notification center
    func onResume() {
        if let lastBill = user?.lastBill {
            billField.text = user!.shouldDisplayLastBill ? lastBill.cleanValue : ""
        }
        animateViews()
    }
}

// Prevent double from unnecessary 0 decimal value being added  
extension Double {
    var cleanValue: String {
        return self % 1 == 0 ? String(format: "%.0f", self) : String(self)
    }
}