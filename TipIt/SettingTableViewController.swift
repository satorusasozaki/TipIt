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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ud = NSUserDefaults.standardUserDefaults()

        setupPercentCells()
    }

    func setupPercentCells() {
        let percents = ud?.objectForKey("percents") as! [Double]
        
        let maxPercent = percents[2]
        changerMaxCell.nameLabel.text = "Max"
        changerMaxCell.percentSlider.setValue(Float(maxPercent)*100, animated: true)
        changerMaxCell.percentLabel.text = "\(String(format: "%.0f", maxPercent*100))%"
        changerMaxCell.percentSlider.addTarget(self, action: #selector(addPercentToUD), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func addPercentToUD(sender: UISlider) {
        if (sender == changerMaxCell.percentSlider) {
            var percents = ud?.objectForKey("percents") as! [Double]
            let sliderValue = Double(sender.value / 100)
            percents[2] = round(100 * sliderValue) / 100
            ud?.setObject(percents, forKey: "percents")
        }
        let tipVC = navigationController?.viewControllers[0] as! TipViewController
        tipVC.redraw()
    }
}
