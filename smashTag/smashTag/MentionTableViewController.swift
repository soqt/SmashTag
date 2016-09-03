//
//  MentionTableViewController.swift
//  smashTag
//
//  Created by Sam Wang on 8/30/16.
//  Copyright © 2016 Sam Wang. AlusersMentionsl rights reserved.
//

import UIKit
import Twitter

class MentionTableViewController: UITableViewController {
//    
//    public var images: [MediaItem]?
//    public var userMentions: [Mention]?
//    public var urls: [Mention]?
//    public var hashtags:[Mention]?
//
    // append each section and corresponding row to mentions
    var tweet: Tweet?{
        didSet{
            if let tweet = self.tweet{
                let media = tweet.media
                if media.count > 0{
                    mentionCollection.append(MentionSection(type: "Images",
                        data: media.map { MentionItem.image($0.url, $0.aspectRatio) }))
                }
                
                let urls = tweet.urls
                if urls.count > 0{
                    mentionCollection.append(MentionSection(type: "URLS",
                        data: urls.map{MentionItem.keyWord($0.keyword)}))
                }
                
                let hashtags = tweet.hashtags
                if hashtags.count > 0{
                    mentionCollection.append(MentionSection(type: "hashtags",
                        data: hashtags.map{MentionItem.keyWord($0.keyword)}))
                }
                
                let userMentions = tweet.userMentions
                if hashtags.count > 0{
                    mentionCollection.append(MentionSection(type: "userMentions",
                        data: userMentions.map{MentionItem.keyWord($0.keyword)}))
                }
                
            }
        }
    }
    
    private var mentionCollection : [MentionSection] = []

    
    private struct MentionSection: CustomStringConvertible {
        var type: String
        var data: [MentionItem]
        var description: String {return "The mention type is \(type) and mention is \(data)"}
    }
    
    private enum MentionItem: CustomStringConvertible {
        case keyWord(String)
        case image(NSURL, Double)
        
        var description: String{
            switch self {
            case .keyWord(let value):
                return "\(value)"
            case let .image(url, aspectRatio):
                return "\(url.absoluteString): \(aspectRatio.description)"
            }
            
        }
    }
    
    

    
    struct StoryBoard {
        static let imageCellIdentifier = "imageCell"
        static let keywordCellIdentifier = "keywordCell"
        static let keywordSearchSegueIdentifier = "searchKeyword"
        static let imageViewSegueIdentifier = "showImage"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mentionCollection.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentionCollection[section].data.count
    }
    
    
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mention = mentionCollection[indexPath.section].data[indexPath.row]
        
        switch mention {
        case let .image(url, aspectRatio):
            let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.imageCellIdentifier, forIndexPath: indexPath) as? ImageTabViewCell
            cell?.imageURL = url
            cell?.setImageRatio(aspectRatio)
            return cell!
        case .keyWord(let keyword):
            let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.keywordCellIdentifier, forIndexPath: indexPath)
            
            cell.textLabel?.text = keyword
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if mentionCollection[section].data.count > 0 {
            return mentionCollection[section].type
        }
        return nil
    }

    // MARK: - Navigation
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == StoryBoard.keywordSearchSegueIdentifier {
            if let thisKeyword = (sender as? UITableViewCell)?.textLabel?.text{
                if thisKeyword.hasPrefix("http"){
                    let url = NSURL(string: thisKeyword)
                    UIApplication.sharedApplication().openURL(url!)
                    return false
                }
            }
        }
        return true
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StoryBoard.keywordSearchSegueIdentifier {
            if let TweetsTableVC = segue.destinationViewController.contentViewController as? TweetsTableViewController{
                if let thisKeyword = (sender as? UITableViewCell)?.textLabel?.text{
                    print(thisKeyword)
                    TweetsTableVC.searchText = thisKeyword
                }
            }
        }else if segue.identifier == StoryBoard.imageViewSegueIdentifier{
            if let imgvc = segue.destinationViewController as? ImageViewController{
                if let cell = (sender as? ImageTabViewCell){
                    imgvc.image = cell.detailImage.image
                    
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
