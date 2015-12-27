//
//  LoadingViewController.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 08.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit
import Foundation

class LoadingViewController: UIViewController {
    @IBOutlet var startButton: UIButton!
    
    var game: Game?
    var config: GameConfiguration?
    
    override func viewDidLoad() {
        startButton.setTitle("Loading", forState: UIControlState.Normal)
        startButton.enabled = false
                
        self.performSelector("configurationLoaded", withObject:nil, afterDelay: 0.4)
    }
    
    func configurationLoaded() {
        startButton.setTitle("Play", forState: UIControlState.Normal)
        startButton.enabled = true
            
        self.config = TimeBasedGameConfiguration(tasks: [
            SortTaskConfiguration(question: "Sort from longest to shortest", questions: [SortTaskItem(title: "5 kg", correctPosition: 1, presentedPosition: 1, errorExplanation: "5 kg = 5000 g"), SortTaskItem(title: "1 kg", correctPosition: 0, presentedPosition: 2, errorExplanation: "1 kg = 1000 g"),
                SortTaskItem(title: "20 kg", correctPosition: 2, presentedPosition: 0, errorExplanation: "20 kg = 20000 g")]),
            NumericTaskConfiguration(fromValue: 4000, fromUnit: "pounds", toValue: 1814, toUnit: "kilograms", minCorrectValue: 1600, maxCorrectValue: 2000, hint: "1 pound is 0.4536 kilograms"),
            ClosedEndedTaskConfiguration(question: "What's heavier?", answers: [ClosedEndedTaskAnswerConfiguration(answer: "1 pound", explanation: "453 grams", correct: false), ClosedEndedTaskAnswerConfiguration(answer: "500 grams", explanation: nil, correct: true)]),
            NumericTaskConfiguration(fromValue: 2, fromUnit: "ounces", toValue: 56.7, toUnit: "grams", minCorrectValue: 50, maxCorrectValue: 60, hint: "1 ounce is 28.35 grams")], time: 60.0)
    }
    
    @IBAction func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? GameViewController, game = game, config = config {
            do {
                try destination.gameRun = game.run(config)
            } catch {                
            }
        }
    }
    
}
