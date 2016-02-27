//
//  APIClient.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 19.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

class APIClient {
    
    static func getConfigurationForGame(game: Game, callback: GameConfiguration -> Void) {
        let config = GameConfiguration(gameRunId: "1", tasks: [
            NumericTaskConfiguration(fromValue: 4000, fromUnit: "pounds", toValue: 1814, toUnit: "kilograms", minCorrectValue: 1600, maxCorrectValue: 2000, image: UIImage(named: "car"), hint: NumericHint(text: "1 pound is 0.4536 kilograms")),            
            SortTaskConfiguration(question: "Sort from shortest to longest", topDescription: "shortest", bottomDescription: "longest", questions: [SortTaskItem(title: "5 kg", correctPosition: 1, presentedPosition: 1, errorExplanation: "5 kg = 5000 g"), SortTaskItem(title: "1 kg", correctPosition: 0, presentedPosition: 2, errorExplanation: "1 kg = 1000 g"),
                SortTaskItem(title: "20 kg", correctPosition: 2, presentedPosition: 0, errorExplanation: "20 kg = 20000 g")]),            
            NumericTaskConfiguration(fromValue: 2, fromUnit: "ounces", toValue: 56.7, toUnit: "grams", minCorrectValue: 50, maxCorrectValue: 60, image: nil, hint: NumericHint(text: "1 ounce is 28.35 grams")),
            ClosedEndedTaskConfiguration(question: "What's heavier?", answers: [ClosedEndedTaskAnswerConfiguration(answer: "1 pound", explanation: "453 grams", correct: false), ClosedEndedTaskAnswerConfiguration(answer: "500 grams", explanation: nil, correct: true)]),
            CurrencyDragTaskConfiguration(fromValue: 23, fromCurrency: "EUR", toValue: 621, toCurrency: "CZK", tolerance: 100, fromNotes: [CurrencyDragTaskConfigurationNote(value: 10, currency: "EUR"), CurrencyDragTaskConfigurationNote(value: 10, currency: "EUR"), CurrencyDragTaskConfigurationNote(value: 1, currency: "EUR"), CurrencyDragTaskConfigurationNote(value: 1, currency: "EUR"), CurrencyDragTaskConfigurationNote(value: 1, currency: "EUR")], correctNotes: [CurrencyDragTaskConfigurationNote(value: 500, currency: "CZK"), CurrencyDragTaskConfigurationNote(value: 100, currency: "CZK"), CurrencyDragTaskConfigurationNote(value: 10, currency: "CZK"), CurrencyDragTaskConfigurationNote(value: 10, currency: "CZK"), CurrencyDragTaskConfigurationNote(value: 1, currency: "CZK")], availableNotes: [(note: CurrencyDragTaskConfigurationNote(value: 1, currency: "CZK"), count: 5), (note: CurrencyDragTaskConfigurationNote(value: 10, currency: "CZK"), count: 2), (note: CurrencyDragTaskConfigurationNote(value: 100, currency: "CZK"), count: 5), (note: CurrencyDragTaskConfigurationNote(value: 500, currency: "CZK"), count: 1)], hint: ScaleHint(topUnit: "EUR", topMin: 0, topMax: 1.11, bottomUnit: "CZK", bottomMin: 0, bottomMax: 30)),
            ScaleTaskConfiguration(task: "How many MILES is 10 KILOMETRES?", scaleMin: 10.0, scaleMax: 23.0, correctValue: 18.21, correctTolerance: 1.0, toUnit: "Miles")
            ])

        let configArea = GameConfiguration(gameRunId: "2", tasks: [
            NumericTaskConfiguration(fromValue: 8, fromUnit: "km²", toValue: 800, toUnit: "ha (hectare)", minCorrectValue: 750, maxCorrectValue: 850, image: nil, hint: NumericHint(text: "1 km² is 100 ha")),
            ScaleTaskConfiguration(task: "Convert 10 km² to mi² (miles squared)", scaleMin: 0, scaleMax: 22, correctValue: 3.86, correctTolerance: 1.0, toUnit: "km²"),
            NumericTaskConfiguration(fromValue: 4, fromUnit: "football fields", toValue: 24000, toUnit: "m²", minCorrectValue: 16000, maxCorrectValue: 40000, image: UIImage(named: "field")!, hint: NumericHint(text: "1 football field is approx. from 4000 to 10000 m²")),
            SortTaskConfiguration(question: "Sort from smallest to largest", topDescription: "smallest", bottomDescription: "largest", questions: [
                SortTaskItem(title: "100 m²", correctPosition: 1, presentedPosition: 2, errorExplanation: ""),
                SortTaskItem(title: "1 ha", correctPosition: 2, presentedPosition: 1, errorExplanation: ""),
                SortTaskItem(title: "1000 in²", correctPosition: 0, presentedPosition: 3, errorExplanation: "1000 in² 0.65 m²"),
                SortTaskItem(title: "50 mi²", correctPosition: 3, presentedPosition: 0, errorExplanation: "50 mi² = 130 km²")
                ]),
            ClosedEndedTaskConfiguration(question: "What's shorter?", answers: [ClosedEndedTaskAnswerConfiguration(answer: "1 mile", explanation: nil, correct: false), ClosedEndedTaskAnswerConfiguration(answer: "1 km", explanation: "1 km = 0.62 mile", correct: true)]),
            NumericTaskConfiguration(fromValue: 3, fromUnit: "yd²", toValue: 27, toUnit: "ft²", minCorrectValue: 25, maxCorrectValue: 30, image: nil, hint: NumericHint(text: "1 yd² = 9 ft²")),
            ScaleTaskConfiguration(task: "Convert 23 m² to ft²", scaleMin: 120, scaleMax: 340, correctValue: 248, correctTolerance: 20, toUnit: "ft²"),
        ])
        
        if game.category == GameCategory.Area {
            callback(configArea)
        } else {
            callback(config)
        }
    }
    
    static func uploadGameRunLog(log: GameRunLog, callback: ((error: NSError?) -> Void)?) {
        if let callback = callback {
            callback(error: nil)
        }
    }
    
}