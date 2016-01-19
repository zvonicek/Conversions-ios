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
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    
    var game: Game?
    var config: GameConfiguration?
    
    override func viewDidLoad() {
        self.nameLabel.text = game?.name
        startButton.setTitle("Loading", forState: UIControlState.Normal)
        startButton.enabled = false
                
        self.performSelector("configurationLoaded", withObject:nil, afterDelay: 0.4)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func configurationLoaded() {
        startButton.setTitle("Play", forState: UIControlState.Normal)
        startButton.enabled = true
            
        self.config = GameConfiguration(tasks: [
            NumericTaskConfiguration(fromValue: 4000, fromUnit: "pounds", toValue: 1814, toUnit: "kilograms", minCorrectValue: 1600, maxCorrectValue: 2000, image: UIImage(named: "car"), hint: NumericHint(text: "1 pound is 0.4536 kilograms")),
            NumericTaskConfiguration(fromValue: 2, fromUnit: "ounces", toValue: 56.7, toUnit: "grams", minCorrectValue: 50, maxCorrectValue: 60, image: nil, hint: NumericHint(text: "1 ounce is 28.35 grams")),
            ClosedEndedTaskConfiguration(question: "What's heavier?", answers: [ClosedEndedTaskAnswerConfiguration(answer: "1 pound", explanation: "453 grams", correct: false), ClosedEndedTaskAnswerConfiguration(answer: "500 grams", explanation: nil, correct: true)]),            
            SortTaskConfiguration(question: "Sort from shortest to longest", questions: [SortTaskItem(title: "5 kg", correctPosition: 1, presentedPosition: 1, errorExplanation: "5 kg = 5000 g"), SortTaskItem(title: "1 kg", correctPosition: 0, presentedPosition: 2, errorExplanation: "1 kg = 1000 g"),
                SortTaskItem(title: "20 kg", correctPosition: 2, presentedPosition: 0, errorExplanation: "20 kg = 20000 g")]),
            CurrencyDragTaskConfiguration(fromValue: 23, fromCurrency: "EUR", toValue: 621, toCurrency: "CZK", tolerance: 100, fromNotes: [CurrencyDragTaskConfigurationNote(value: 10, currency: "EUR"), CurrencyDragTaskConfigurationNote(value: 10, currency: "EUR"), CurrencyDragTaskConfigurationNote(value: 1, currency: "EUR"), CurrencyDragTaskConfigurationNote(value: 1, currency: "EUR"), CurrencyDragTaskConfigurationNote(value: 1, currency: "EUR")], correctNotes: [CurrencyDragTaskConfigurationNote(value: 500, currency: "CZK"), CurrencyDragTaskConfigurationNote(value: 100, currency: "CZK"), CurrencyDragTaskConfigurationNote(value: 10, currency: "CZK"), CurrencyDragTaskConfigurationNote(value: 10, currency: "CZK"), CurrencyDragTaskConfigurationNote(value: 1, currency: "CZK")], availableNotes: [(note: CurrencyDragTaskConfigurationNote(value: 1, currency: "CZK"), count: 5), (note: CurrencyDragTaskConfigurationNote(value: 10, currency: "CZK"), count: 2), (note: CurrencyDragTaskConfigurationNote(value: 100, currency: "CZK"), count: 5), (note: CurrencyDragTaskConfigurationNote(value: 500, currency: "CZK"), count: 1)], hint: ScaleHint(topUnit: "EUR", topMin: 0, topMax: 1.11, bottomUnit: "CZK", bottomMin: 0, bottomMax: 30)),
            ScaleTaskConfiguration(task: "How many MILES is 10 KILOMETRES?", scaleMin: 10.0, scaleMax: 23.0, correctValue: 18.21, correctTolerance: 1.0)
        ])
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
