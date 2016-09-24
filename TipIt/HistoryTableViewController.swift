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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user!.billRecords!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath as IndexPath) as! HistoryCell
        let record = user!.billRecords![indexPath.row]
        cell.dateLabel.text = record.date
        cell.totalLabel.text = record.total
        return cell
    }

    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyDetailVC = storyboard?.instantiateViewController(withIdentifier: "historyDetailViewController") as! HistoryDetailViewController
        historyDetailVC.index = indexPath.row
        self.navigationController?.pushViewController(historyDetailVC, animated: true)
    }

}
