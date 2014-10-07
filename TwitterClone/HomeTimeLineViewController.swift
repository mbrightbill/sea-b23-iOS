//
//  HomeTimeLineViewController.swift
//  TwitterClone
//
//  Created by Bradley Johnson on 10/6/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit
import Accounts
import Social

class HomeTimeLineViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets : [Tweet]?
    var twitterAccount : ACAccount?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
            if granted {
                
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                //setup our twitter request
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    
                    switch httpResponse.statusCode {
                    case 200...299:
                        self.tweets = Tweet.parseJSONDataIntoTweets(data)
                        println(self.tweets?.count)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.tableView.reloadData()
                        })
                        //right here, we are on a background queue aka thread
                    case 400...499:
                        println("this is the clients fault")
                        println(httpResponse.description)
                    case 500...599:
                        println("this is the servers fault")
                    default:
                        println("something bad happened")
                    }
                    
                })
            }
        }
        
        println("Hello")
        

//        if let path = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
//            var error : NSError?
//            let jsonData = NSData(contentsOfFile: path)
//            
//            self.tweets = Tweet.parseJSONDataIntoTweets(jsonData)
//        }
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //step 1 dequeue the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as UITableViewCell
        //step 2 figure out which model object youre going to use to configure the cell
        //this is where we would grab a reference to the correct tweet and use it to configure the cell
        let tweet = self.tweets?[indexPath.row]
        cell.textLabel?.text = tweet?.text
        //step 3 return the cell
        return cell
    }
}
