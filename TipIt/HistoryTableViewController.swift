//
//  HistoryTableViewController.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 9/8/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    private var user: UserManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = UserManager()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user!.billRecords!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! HistoryCell
        let record = user!.billRecords![indexPath.row]
        cell.dateLabel.text = record.date
        cell.totalLabel.text = record.total
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let historyDetailVC = storyboard?.instantiateViewControllerWithIdentifier("historyDetailViewController") as! HistoryDetailViewController
        historyDetailVC.index = indexPath.row
        self.navigationController?.pushViewController(historyDetailVC, animated: true)
    }
}
