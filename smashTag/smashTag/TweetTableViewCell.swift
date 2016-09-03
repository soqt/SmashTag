//
//  TweetTableViewCell.swift
//  smashTag
//
//  Created by Sam Wang on 8/29/16.
//  Copyright © 2016 Sam Wang. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet?{
        didSet {
            updateUI()
        }
    }
    
    struct Color {
        static let hashTagColor = UIColor.blueColor()
        static let urlsColor = UIColor.brownColor()
        static let userMentionsColor = UIColor.orangeColor()
    }
    
    // update UI
    private func updateUI() {
        // Remove everything that currently in the UI
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        
        if let tweet = self.tweet {
            // tweet Text Label
            tweetTextLabel?.text = tweet.text
            
            if tweetTextLabel?.text != nil  {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
                
               
                
                let attributedText = NSMutableAttributedString(string: tweetTextLabel.text!)
                
                
                for word in tweet.hashtags {
                    attributedText.addAttribute(NSForegroundColorAttributeName, value: Color.hashTagColor, range: word.nsrange)
                }
                
                for word in tweet.urls {
                    attributedText.addAttribute(NSForegroundColorAttributeName, value: Color.urlsColor, range: word.nsrange)
                }
                
                for word in tweet.userMentions {
                    attributedText.addAttribute(NSForegroundColorAttributeName, value: Color.userMentionsColor, range: word.nsrange)
                }
                
                tweetTextLabel.attributedText = attributedText
                
                
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
            
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
                    let contentsOfURL = NSData(contentsOfURL: profileImageURL)
                    dispatch_async(dispatch_get_main_queue()){
                        if profileImageURL == tweet.user.profileImageURL{
                            if let imageURL = contentsOfURL{
                                self.tweetProfileImageView?.image = UIImage(data: imageURL)
                            }
                        }else{
                            print("error")
                        }
                    }
                    
                }
            }
        }
        
    }
}


