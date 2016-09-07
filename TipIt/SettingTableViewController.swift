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
        themeSwitch.setOn((user?.theme)!, animated: true)
        setupPercentCell(changerMaxCell, text: "Max", index: 2)
        setupPercentCell(changerMidCell, text: "Mid", index: 1)
        setupPercentCell(changerMinCell, text: "Min", index: 0)
    }

    func setupPercentCell(cell: ChangerCell, text: String, index: Int) {
        let percent = Float((user?.percents![index])! * 100)
        cell.percentSlider.setValue(percent, animated: true)
        cell.percentLabel.text = "\(String(format: "%.0f", percent))%"
        cell.percentSlider.addTarget(self, action: #selector(addPercentToUD), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func addPercentToUD(sender: UISlider) {
        let sliderValue = Double(sender.value / 100)
        let percent = round(100 * sliderValue) / 100
        var percents = user?.percents
        if (sender == changerMaxCell.percentSlider) {
            percents![2] = percent
        } else if (sender == changerMidCell.percentSlider) {
            percents![1] = percent
        } else {
            percents![0] = percent
        }
        user?.percents = percents
        tipViewController!.setupLabelTexts()
        tipViewController!.setupPercentControl()
    }
    
    @IBAction func onThemeSwitch(sender: UISwitch) {
        let switchState = sender.on ? true : false
        user?.theme = switchState
        tipViewController?.setupTheme()
    }
}
