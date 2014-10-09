//
//  Tweet.swift
//  TwitterClone
//
//  Created by Bradley Johnson on 10/6/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class Tweet {
    
    var text : String
    var avatarURL : String
    var avatarImage : UIImage?
    
    init ( tweetInfo : NSDictionary) {
        self.text = tweetInfo["text"] as String
        let userInfo = tweetInfo["user"] as NSDictionary
        self.avatarURL = userInfo["profile_image_url"] as String
    }
    
    class func parseJSONDataIntoTweets(rawJSONData : NSData ) -> [Tweet]? {
        var error : NSError?
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray {
            
            var tweets = [Tweet]()
            
            for JSONDictionary in JSONArray {
                if let tweetDictionary = JSONDictionary as? NSDictionary {
                    var newTweet = Tweet(tweetInfo: tweetDictionary)
                    tweets.append(newTweet)
                }
            }
            return tweets
        }
        return nil
    }
    
    
    
}
