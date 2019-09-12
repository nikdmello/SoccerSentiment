import Cocoa
import CreateML

// data used to train ml model
let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/Nikhil/Desktop/AppDev/StockTweets/sentiment_m140_.csv"))
///Users/Nikhil/Downloads/twitter-sanders-apple3.csv
///Users/Nikhil/Desktop/AppDev/StockTweets/training.1600000.processed.noemoticon.csv
// split of training and testing data
let(trainingData, testingData) = data.randomSplit(by: 0.8, seed: 1)

// instantiates nlp ml model with training data
let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")


// Computes testing metrics on the given labeled data
let evaluationMetrics = sentimentClassifier.evaluation(on: testingData)

// The fraction of examples incorrectly labeled by this model
let evaluationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100

// metadata
let metadata = MLModelMetadata(author: "Nikhil D", shortDescription: "Cool stuff", version: "1")

// writes mlmodel
try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/Nikhil/Downloads/model.mlmodel"))

// tests
try sentimentClassifier.prediction(from: "I love this")
try sentimentClassifier.prediction(from: "Apple is bad")
