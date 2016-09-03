//
//  HistoryTableViewController.swift
//  smashTag
//
//  Created by Sam Wang on 9/1/16.
//  Copyright © 2016 Sam Wang. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    private var histories:[String] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.histories = HistoryStorage().values
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.historyCellIdentifier, forIndexPath: indexPath)
        let thisHistory = histories[indexPath.row]
        cell.textLabel?.text = thisHistory
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            HistoryStorage().removeAtIndex(indexPath.row)
            histories = HistoryStorage().values
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    private struct StoryBoard{
        static let historyCellIdentifier = "historyCell"
        static let searchSegueIdentifier = "searchThisMention"
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StoryBoard.searchSegueIdentifier{
            if let tweetsTableVC = segue.destinationViewController as? TweetsTableViewController{
                if let searchText = (sender as? UITableViewCell)?.textLabel?.text{
                    tweetsTableVC.searchText = searchText
                }
            }
        }
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
    

}
