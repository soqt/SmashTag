//
//  TweetsTableViewController.swift
//  smashTag
//
//  Created by Sam Wang on 8/29/16.
//  Copyright © 2016 Sam Wang. All rights reserved.
//

import UIKit
import Twitter

class TweetsTableViewController: UITableViewController, UITextFieldDelegate {
    
    // Sections created by each fetching
    // Rows are the number of tweets in each section
    var tweets = [Array<Twitter.Tweet>](){
        didSet{
            tableView.reloadData()
        }
    }
    
    // 1) load
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        title = "Smash Tag"
        searchTweet.text = "#Pokemon"
        searchText = searchTweet.text
    }
    
    // 2) search text
    var searchText: String?{
        didSet{
            lastTweet = nil
            tweets.removeAll()
            searchForTweets()
        }
    }
    
    
    private var twitterRequest: Twitter.Request? {
        if let text = searchText where !text.isEmpty {
            return Twitter.Request(search: text + " -filter:retweets", count: 50)
        }else{
            return nil
        }
    }
    
    private var lastTweet: Twitter.Request?
    
    // 3) fetch tweets
    private func searchForTweets() {
        HistoryStorage().add(searchText!)
        if let request = twitterRequest {
            lastTweet = request
            request.fetchTweets{ [weak weakSelf = self]newTweet in
                dispatch_async(dispatch_get_main_queue()){
                    if !newTweet.isEmpty && weakSelf?.lastTweet == request{
                        weakSelf?.tweets.insert(newTweet, atIndex: 0)
                    }
                }
            }

        }
    }


    @IBOutlet weak var searchTweet: UITextField!{
        didSet{
            searchTweet.delegate = self
            searchTweet.text = searchText
        }
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(!(textField.text?.isEmpty)!){
            searchText = textField.text
        }
        return true
    }
    

    
    
    
    // MARK: - Table view data source
    // Heart of dynamic UI table

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.TweetCellIdentifier, forIndexPath: indexPath) as? TweetTableViewCell
        
        let tweet = tweets[indexPath.section][indexPath.row]
        
        cell?.tweet = tweet
        
        return cell!
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StoryBoard.showDetail{
            if let mentionVC = segue.destinationViewController.contentViewController as? MentionTableViewController{
                if let currentTweet = (sender as? TweetTableViewCell)?.tweet{
                    mentionVC.title = currentTweet.user.screenName
                    mentionVC.navigationItem.title = currentTweet.user.screenName
                    mentionVC.tweet = currentTweet
                }
            }
        }
    }
    
    private struct StoryBoard{
        static let TweetCellIdentifier = "Tweet"
        static let showDetail = "showDetail"
    }
    

}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
