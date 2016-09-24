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
        setupPercentCell(cell: changerMaxCell, text: "Max", index: 2)
        setupPercentCell(cell: changerMidCell, text: "Mid", index: 1)
        setupPercentCell(cell: changerMinCell, text: "Min", index: 0)
        color = ColorManager(status: user!.theme!)
        setupSliderColor(slider: changerMaxCell.percentSlider)
        setupSliderColor(slider: changerMidCell.percentSlider)
        setupSliderColor(slider: changerMinCell.percentSlider)
    }
    
    // MARK: - Percent Cell
    
    func setupSliderColor(slider: UISlider) {
        //slider.tintColor = color?.mainColor
    }

    func setupPercentCell(cell: ChangerCell, text: String, index: Int) {
        let percent = Float((user?.percents![index])! * 100)
        cell.percentSlider.setValue(percent, animated: true)
        cell.nameLabel.text = text
        cell.percentLabel.text = "\(String(format: "%.0f", percent))%"
        cell.percentSlider.addTarget(self, action: #selector(addPercentToUD), for: UIControlEvents.touchUpInside)
    }
    
    func addPercentToUD(sender: UISlider) {
        let percentInt = Int(sender.value)
        let percentDouble = Double(percentInt)
        let percent = percentDouble / 100
        
        print("percent: \(percent)")
        print("sender.value: \(sender.value)")
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
    
    // MARK: - Theme
    
    @IBAction func onThemeSwitch(sender: UISwitch) {
        user?.theme = sender.isOn
        tipViewController?.setupTheme()
        color?.colorStatus = user?.theme
        setupSliderColor(slider: changerMaxCell.percentSlider)
        setupSliderColor(slider: changerMidCell.percentSlider)
        setupSliderColor(slider: changerMinCell.percentSlider)
    }
    
    // MARK: - Transition to detail view

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell == historyCell {
                let historyTVC = storyboard?.instantiateViewController(withIdentifier: "historyTableViewController") as! HistoryTableViewController
                self.navigationController?.pushViewController(historyTVC, animated: true)
            }
        }
    }

}
