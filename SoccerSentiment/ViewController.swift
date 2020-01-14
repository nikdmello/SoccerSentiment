//
//  ViewController.swift
//  SoccerSentiment
//
//  Created by Nikhil D'Mello on 9/11/19.
//  Copyright © 2019 Nikhil D'Mello. All rights reserved.
//

import UIKit
import SwifteriOS
import SwiftyJSON
import LTMorphingLabel

class ViewController: UIViewController, LTMorphingLabelDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var sentimentLabel: LTMorphingLabel!
    
    @IBOutlet weak var teamPicker: UIPickerView!
    
    // Teams currently in the 2020 Premier League.
    let teamArray = ["Arsenal", "Aston Villa", "Bournemouth", "Brighton", "Burnley FC", "Chelsea", "Crystal Palace", "Everton", "Leicester City", "Liverpool", "Manchester City", "Manchester United", "Newcastle", "Norwich City", "Sheff Utd", "Southampton", "Tottenham", "Watford", "West Ham", "Wolves"]
    
    // Number of tweets returned
    let tweetCount = 100
        
    // Instantiates ml model
    let sentimentClassifier = StockClassifier()
    // Instantiates Twitter framework using OAuth Consumer Key and Secret
    // API keys are hidden
    let swifter = Swifter(consumerKey: Bundle.main.object(forInfoDictionaryKey: "ConsumerKey") as! String, consumerSecret: Bundle.main.object(forInfoDictionaryKey: "ConsumerSecret") as! String)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        teamPicker.delegate = self
        teamPicker.dataSource = self
    }
    
    //MARK: - PickerView delegate methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teamArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teamArray[row]
    }
    
    // Passes the Selected team name as an argument to fetch tweets.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fetchTweets(searchText: teamArray[row])
    }
    
    //MARK: - Networking
    
    // Fetches tweet data
    func fetchTweets(searchText: String) {
        // Returns a collection of relevant Tweets matching a specified query.
        swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended, success: { (results, metadata) in
            
            // Tweet data to be passed
            var tweetArray = [StockClassifierInput]()
            
            // Parses JSON data into an array of tweets
            for i in 0..<self.tweetCount {
                if let tweet = results[i]["full_text"].string {
                    let classifierTweetInput = StockClassifierInput(text: tweet)
                    tweetArray.append(classifierTweetInput)
            
                }
            }
            
            self.generateSentiment(tweetArray: tweetArray)
            
        }) { (error) in
            fatalError()
        }
    }
    
    //MARK: - Calculation logic
    
    // Genearates sentiment of the given tweets
    func generateSentiment(tweetArray : [StockClassifierInput]) {
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
                
                print(pred.label)
            }
            
            sentimentLabel.text = String(sentimentScore)
            
        }
        catch {
            print(error)
        }
    }
}

