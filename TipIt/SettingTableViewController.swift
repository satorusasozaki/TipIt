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
    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var historyCell: UITableViewCell!
    
    private var tipViewController: TipViewController?
    private var user: UserManager?
    private var color: ColorManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = UserManager()
        tipViewController = navigationController?.viewControllers[0] as? TipViewController
        themeSwitch.setOn((user?.theme)!, animated: true)
        setupPercentCell(changerMaxCell, text: "Max", index: 2)
        setupPercentCell(changerMidCell, text: "Mid", index: 1)
        setupPercentCell(changerMinCell, text: "Min", index: 0)
        color = ColorManager(status: user!.theme!)
        setupSliderColor(changerMaxCell.percentSlider)
        setupSliderColor(changerMidCell.percentSlider)
        setupSliderColor(changerMinCell.percentSlider)
    }
    
    func setupSliderColor(slider: UISlider) {
        slider.tintColor = color?.mainColor
    }

    func setupPercentCell(cell: ChangerCell, text: String, index: Int) {
        let percent = Float((user?.percents![index])! * 100)
        cell.percentSlider.setValue(percent, animated: true)
        cell.nameLabel.text = text
        cell.percentLabel.text = "\(String(format: "%.0f", percent))%"
        cell.percentSlider.addTarget(self, action: #selector(addPercentToUD), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func addPercentToUD(sender: UISlider) {
        let percent = round(100 * Double(sender.value / 100)) / 100
        if (sender == changerMaxCell.percentSlider) {
            user?.percents![2] = percent
        } else if (sender == changerMidCell.percentSlider) {
            user?.percents![1] = percent
        } else {
            user?.percents![0] = percent
        }
        tipViewController!.setupLabelTexts()
        tipViewController!.setupPercentControl()
    }
    
    @IBAction func onThemeSwitch(sender: UISwitch) {
        let switchState = sender.on ? true : false
        user?.theme = switchState
        tipViewController?.setupTheme()
        color?.colorStatus = user?.theme
        setupSliderColor(changerMaxCell.percentSlider)
        setupSliderColor(changerMidCell.percentSlider)
        setupSliderColor(changerMinCell.percentSlider)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell == historyCell {
                print("THIS")
                let historyTVC = storyboard?.instantiateViewControllerWithIdentifier("historyTableViewController") as! HistoryTableViewController
                self.navigationController?.pushViewController(historyTVC, animated: true)
            }
        }
    }
}
