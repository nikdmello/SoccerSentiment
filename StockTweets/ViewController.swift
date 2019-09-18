//
//  ViewController.swift
//  StockTweets
//
//  Created by Nikhil D'Mello on 9/11/19.
//  Copyright © 2019 Nikhil D'Mello. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {

    @IBOutlet weak var sentimentLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
    }
    
    let sentimentClassifier = classifier()
    let swifter = Swifter(consumerKey: "ueIGM8S7NpUnAAgK3NFTXIrCP", consumerSecret: "vPPKsRqWxy1hWfiloAs6UjJXVFuGR6qquxDNCFFrNhjcNKANAT")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let prediction = try! sentimentClassifier.prediction(text: "i love apple")
        print(prediction.label)
        
        swifter.searchTweet(using: "Tesla", lang: "en", count: 100, tweetMode: .extended, success: { (results, metadata) in
            print(results)
        }) { (error) in
            print(error)
        }
    }


}

