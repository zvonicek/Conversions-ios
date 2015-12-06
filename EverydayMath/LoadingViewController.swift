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
        
        self.config = TimeBasedGameConfiguration(tasks: [NumericTaskConfiguration(fromValue: 4000, fromUnit: "pounds", toValue: 1814, toUnit: "kilograms", minCorrectValue: 1600, maxCorrectValue: 2000, hint: "1 pound is 0.4536 kilograms"), ClosedEndedTaskConfiguration(question: "What's heavier?", answers: [ClosedEndedTaskAnswerConfiguration(answer: "1 pound", explanation: "453 grams", correct: false), ClosedEndedTaskAnswerConfiguration(answer: "500 grams", explanation: nil, correct: true)]), NumericTaskConfiguration(fromValue: 2, fromUnit: "ounces", toValue: 56.7, toUnit: "grams", minCorrectValue: 50, maxCorrectValue: 60, hint: "1 ounce is 28.35 grams")], time: 60.0)
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
