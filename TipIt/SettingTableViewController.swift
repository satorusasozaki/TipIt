//
//  SettingTableViewController.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 8/27/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var changerMaxCell: ChangerCell!
    @IBOutlet weak var changerMidCell: ChangerCell!
    @IBOutlet weak var changerMinCell: ChangerCell!
    
    var tipViewController: TipViewController?
    var user: UserManager?
    
    @IBOutlet weak var themeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = UserManager()
        tipViewController = navigationController?.viewControllers[0] as? TipViewController
        setupPercentCells()
        themeSwitch.setOn((user?.getTheme())!, animated: true)
    }

    func setupPercentCells() {
        
        let maxPercent = Float((user?.getPercentAtIndex(2))! * 100)
        changerMaxCell.nameLabel.text = "Max"
        changerMaxCell.percentSlider.setValue(maxPercent, animated: true)
        changerMaxCell.percentLabel.text = "\(String(format: "%.0f", maxPercent))%"
        changerMaxCell.percentSlider.addTarget(self, action: #selector(addPercentToUD), forControlEvents: UIControlEvents.TouchUpInside)
 
        let midPercent = Float((user?.getPercentAtIndex(1))! * 100)
        changerMidCell.nameLabel.text = "Mid"
        changerMidCell.percentSlider.setValue(midPercent, animated: true)
        changerMidCell.percentLabel.text = "\(String(format: "%.0f", midPercent))%"
        changerMidCell.percentSlider.addTarget(self, action: #selector(addPercentToUD), forControlEvents: UIControlEvents.TouchUpInside)
        
        let minPercent = Float((user?.getPercentAtIndex(0))! * 100)
        changerMinCell.nameLabel.text = "Min"
        changerMinCell.percentSlider.setValue(minPercent, animated: true)
        changerMinCell.percentLabel.text = "\(String(format: "%.0f", minPercent))%"
        changerMinCell.percentSlider.addTarget(self, action: #selector(addPercentToUD), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func addPercentToUD(sender: UISlider) {
        let sliderValue = Double(sender.value / 100)
        if (sender == changerMaxCell.percentSlider) {
            let percent = round(100 * sliderValue) / 100
            user?.setPercentAtIndex(2, value: percent)
        } else if (sender == changerMidCell.percentSlider) {
            let percent = round(100 * sliderValue) / 100
            user?.setPercentAtIndex(1, value: percent)
        } else {
            let percent = round(100 * sliderValue) / 100
            user?.setPercentAtIndex(0, value: percent)
        }
        tipViewController!.redraw()
    }
    
    @IBAction func onThemeSwitch(sender: UISwitch) {
        // get it from nsuserdefault
        // add method to change color in tip calc
        let switchState = sender.on ? true : false
        user?.setTheme(switchState)
        tipViewController?.updateTheme()
    }
    // switch
}
