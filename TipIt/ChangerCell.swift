//
//  ChangerCell.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 8/27/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class ChangerCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var percentSlider: UISlider!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        percentLabel.text = "\(currentValue)%"
    }
}
