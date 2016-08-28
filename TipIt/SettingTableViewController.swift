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
    
    var ud: NSUserDefaults?
    var tipViewController: TipViewController?
    
    @IBOutlet weak var themeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ud = NSUserDefaults.standardUserDefaults()
        tipViewController = navigationController?.viewControllers[0] as? TipViewController
        setupPercentCells()
        let switchState = ud?.objectForKey("theme") as! Bool
        themeSwitch.setOn(switchState, animated: true)
    }

    func setupPercentCells() {
        let percents = ud?.objectForKey("percents") as! [Double]
        
        let maxPercent = Float(percents[2] * 100)
        changerMaxCell.nameLabel.text = "Max"
        changerMaxCell.percentSlider.setValue(maxPercent, animated: true)
        changerMaxCell.percentLabel.text = "\(String(format: "%.0f", maxPercent))%"
        changerMaxCell.percentSlider.addTarget(self, action: #selector(addPercentToUD), forControlEvents: UIControlEvents.TouchUpInside)
 
        let midPercent = Float(percents[1] * 100)
        changerMidCell.nameLabel.text = "Mid"
        changerMidCell.percentSlider.setValue(midPercent, animated: true)
        changerMidCell.percentLabel.text = "\(String(format: "%.0f", midPercent))%"
        changerMidCell.percentSlider.addTarget(self, action: #selector(addPercentToUD), forControlEvents: UIControlEvents.TouchUpInside)
        
        let minPercent = Float(percents[0] * 100)
        changerMinCell.nameLabel.text = "Min"
        changerMinCell.percentSlider.setValue(minPercent, animated: true)
        changerMinCell.percentLabel.text = "\(String(format: "%.0f", minPercent))%"
        changerMinCell.percentSlider.addTarget(self, action: #selector(addPercentToUD), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func addPercentToUD(sender: UISlider) {
        var percents = ud?.objectForKey("percents") as! [Double]
        if (sender == changerMaxCell.percentSlider) {
            let sliderValue = Double(sender.value / 100)
            percents[2] = round(100 * sliderValue) / 100
            ud?.setObject(percents, forKey: "percents")
        } else if (sender == changerMidCell.percentSlider) {
            let sliderValue = Double(sender.value / 100)
            percents[1] = round(100 * sliderValue) / 100
            ud?.setObject(percents, forKey: "percents")
        } else {
            let sliderValue = Double(sender.value / 100)
            percents[0] = round(100 * sliderValue) / 100
            ud?.setObject(percents, forKey: "percents")
        }
        tipViewController!.redraw()
    }
    
    @IBAction func onThemeSwitch(sender: UISwitch) {
        // get it from nsuserdefault
        // add method to change color in tip calc
        let switchState = sender.on ? true : false
        ud?.setObject(switchState, forKey: "theme")
        tipViewController?.updateTheme()
    }
    // switch
}
