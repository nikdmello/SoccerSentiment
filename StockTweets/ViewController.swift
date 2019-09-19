//
//  ViewController.swift
//  StockTweets
//
//  Created by Nikhil D'Mello on 9/11/19.
//  Copyright © 2019 Nikhil D'Mello. All rights reserved.
//

import UIKit
import SwifteriOS
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var sentimentLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    // Number of tweets returned
    let tweetCount = 100
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if let searchBar = textField.text {
            fetchTweets(searchText: searchBar)
        }
    }
    
    // Instantiates ml model
    let sentimentClassifier = Classifier()
    // Instantiates Twitter framework using OAuth Consumer Key and Secret
    let swifter = Swifter(consumerKey: "ueIGM8S7NpUnAAgK3NFTXIrCP", consumerSecret: "vPPKsRqWxy1hWfiloAs6UjJXVFuGR6qquxDNCFFrNhjcNKANAT")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Fetches tweet data
    func fetchTweets(searchText: String) {
        // Returns a collection of relevant Tweets matching a specified query.
        swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended, success: { (results, metadata) in
            
            // Tweet data to be passed
            var tweetArray = [ClassifierInput]()
            
            // Parses JSON data into an array of tweets
            for i in 0..<self.tweetCount {
                if let tweet = results[i]["full_text"].string {
                    let classifierTweetInput = ClassifierInput(text: tweet)
                    tweetArray.append(classifierTweetInput)
                }
            }
            
            self.generateSentiment(tweetArray: tweetArray)
            
        }) { (error) in
            fatalError()
        }
    }
    
    // Generates sentiment of the given tweets
    func generateSentiment(tweetArray : [ClassifierInput]) {
        var sentimentScore = 0
        
        do {
            // Make a batch prediction using the structured interface.
            let predictions = try self.sentimentClassifier.predictions(inputs: tweetArray)
            
            // Calculates the total sentiment score out of 100.
            for pred in predictions {
                if pred.label == "pos" {
                    sentimentScore += 1
                }
                else {
                    sentimentScore -= 1
                }
            }
            print(sentimentScore)
        }
        catch {
            print(error)
        }
    }
}

