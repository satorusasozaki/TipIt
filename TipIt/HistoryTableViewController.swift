//
//  HistoryTableViewController.swift
//  TipIt
//
//  Created by Satoru Sasozaki on 9/8/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    var user: UserManager?
    var records: [[String:String]]?
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.registerClass(HistoryCell.self, forCellReuseIdentifier: "historyCell")
        user = UserManager()
        records = user?.records
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! HistoryCell
        let record = records![indexPath.row]
        cell.dateLabel.text = record[UserManager.dateRecordKey]
        cell.totalLabel.text = record[UserManager.totalRecordKey]

        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let historyDetailVC = storyboard?.instantiateViewControllerWithIdentifier("historyDetailViewController") as! HistoryDetailViewController
//        let record = records![indexPath.row]
//        historyDetailVC.viewDidLoad()
//        historyDetailVC.dateLabel.text = record[UserManager.dateRecordKey]
//        historyDetailVC.billLabel.text = record[UserManager.billRecordKey]
//        historyDetailVC.tipAmountLabel.text = record[UserManager.tipPercentRecordKey]
//        historyDetailVC.totalAmountLabel.text = record[UserManager.totalRecordKey]
        historyDetailVC.index = indexPath.row
        self.navigationController?.pushViewController(historyDetailVC, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
