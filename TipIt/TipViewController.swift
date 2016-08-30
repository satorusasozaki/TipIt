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
    
    @IBOutlet weak var billViewTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var labelsView: UIView!
    @IBOutlet weak var labelsViewTopConstraint: NSLayoutConstraint!
    
    var textFieldIsEmpty: Bool?
    var user: UserManager?
    
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
        print("view will disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        billField.delegate = self
        billField.addTarget(self, action: #selector(TipViewController.updateLabels), forControlEvents: UIControlEvents.EditingChanged)
        billField.addTarget(self, action: #selector(TipViewController.animateViews), forControlEvents: UIControlEvents.EditingChanged)
        percentControl.addTarget(self, action: #selector(TipViewController.updateLabels), forControlEvents: UIControlEvents.ValueChanged)
        
        // Default setting
        user = UserManager()
        user?.setPercentAtIndex(0, value: 0.1)
        user?.setPercentAtIndex(1, value: 0.15)
        user?.setPercentAtIndex(2, value: 0.29)
        user?.setTheme(false)
        setupPercentControl()
        updateTheme()
        print(getCurrencySymbol())
        billField.placeholder = getCurrencySymbol()
        
        billViewTopConstraint.constant = getTopConstraint(false)
        self.labelsView.alpha = 0

        setLabelConstraints(false)
        
        textFieldIsEmpty = true
        
        
        billField.becomeFirstResponder()
    }
    
    private func saveFieldValueToNSUserDefault() {
        
    }
    
    func animateViews() {
        // research let if
        if (!textFieldIsEmpty! && billField.text!.isEmpty) {
            textFieldIsEmpty = true
            billViewTopConstraint.constant = getTopConstraint(false)
            setLabelConstraints(false)
            self.labelsView.alpha = 1
            UIView.animateWithDuration(0.4, animations: {
                self.labelsView.alpha = 0
                self.view.layoutIfNeeded()
            })
        } else if (textFieldIsEmpty! && !billField.text!.isEmpty){
            textFieldIsEmpty = false
            billViewTopConstraint.constant = getTopConstraint(true)
            setLabelConstraints(true)
            self.labelsView.alpha = 0
            UIView.animateWithDuration(0.4, animations: {
                self.labelsView.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func setLabelConstraints(isAnimated: Bool) {
        if(isAnimated) {
            labelsViewTopConstraint.constant = 30
        } else {
            labelsViewTopConstraint.constant = 100
        }
    }
    
    private func getTopConstraint(isAnimated: Bool) -> CGFloat{
        if (isAnimated) {
            return 0
        }
        return UIScreen.mainScreen().bounds.size.height / 3
    }
    

    @IBAction func onTapTipViewController(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func updateTheme() {        
        if let themeState = user?.getTheme() {
            if themeState {
                view.backgroundColor = UIColor.blackColor()
            } else {
                view.backgroundColor = UIColor.whiteColor()
            }
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
//        let percent = ud?.objectForKey("percents")![percentControl.selectedSegmentIndex] as! Double
        let percent = user?.getPercents()[percentControl.selectedSegmentIndex]
        return percent!
    }
    
    private func setupPercentControl() {
        let percents = user?.getPercents()
        for index in 0..<percents!.count {
            let percent = String(format: "%.0f", percents![index]*100)
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
