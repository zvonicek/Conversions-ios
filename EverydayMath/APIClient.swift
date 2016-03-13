//
//  APIClient.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 19.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import Unbox

class APIClient {
    
    static let baseUrl = "http://localhost:5000"
    
    static func getConfigurationForTask(task: Task) -> Promise<TaskConfiguration> {
        let user: String
        if let storedUser = NSUserDefaults.standardUserDefaults().objectForKey("user") as? String {
            user = storedUser
        } else {
            user = NSUUID().UUIDString
            NSUserDefaults.standardUserDefaults().setObject(user, forKey: "user")
        }
        
        let language = NSLocale.preferredLanguages().first ?? ""
        let versionNumber = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        
        return Alamofire.request(.GET, self.baseUrl + "/api/start", parameters: ["task": task.identifier, "user": user, "language":language, "version": versionNumber], encoding: ParameterEncoding.URL)
            .promiseUnboxableJSON()
            .then({ dictionary -> TaskConfiguration in
                do {
                    let config: TaskConfiguration = try UnboxOrThrow(dictionary)
                    return config
                } catch {
                    throw Error.errorWithCode(1, failureReason: "JSON deserialization failed")
                }
            }).then({ configuration in
                let numQuestions = configuration.questions.flatMap({ $0 as? NumericQuestionConfiguration}).filter({ $0.imagePath != nil})
                
                var imagePromises = [Promise<Void>]()
                for numQuestion in numQuestions {
                    imagePromises.append(Alamofire.request(.GET, self.baseUrl + numQuestion.imagePath!).promiseImage().then({ image in
                        numQuestion.image = image
                    }))
                }
                
                return when(imagePromises).then({ a in
                    return configuration
                })
            })
    }
    
    static func uploadTaskRunLog(log: TaskRunLog) -> Promise<Void> {
        return Alamofire.request(.POST, self.baseUrl + "/api/updateTaskRun", parameters: log.serialize(), encoding: ParameterEncoding.JSON)
            .promiseResponse()
    }    
    
//        let config = TaskConfiguration(taskRunId: "1", questions: [
//                NumericQuestionConfiguration(fromValue: 4000, fromUnit: "pounds", toValue: 1814, toUnit: "kilograms", minCorrectValue: 1600, maxCorrectValue: 2000, image: UIImage(named: "car"), hint: NumericHint(text: "1 pound is 0.4536 kilograms")),
//                SortQuestionConfiguration(question: "Sort from shortest to longest", topDescription: "shortest", bottomDescription: "longest", questions: [SortQuestionItem(title: "5 kg", correctPosition: 1, presentedPosition: 1, errorExplanation: "5 kg = 5000 g"), SortQuestionItem(title: "1 kg", correctPosition: 0, presentedPosition: 2, errorExplanation: "1 kg = 1000 g"),
//                                                                                                                                                           SortQuestionItem(title: "20 kg", correctPosition: 2, presentedPosition: 0, errorExplanation: "20 kg = 20000 g")]),
//                NumericQuestionConfiguration(fromValue: 2, fromUnit: "ounces", toValue: 56.7, toUnit: "grams", minCorrectValue: 50, maxCorrectValue: 60, image: nil, hint: NumericHint(text: "1 ounce is 28.35 grams")),
//                ClosedEndedQuestionConfiguration(question: "What's heavier?", answers: [ClosedEndedQuestionAnswerConfiguration(answer: "1 pound", explanation: "453 grams", correct: false), ClosedEndedQuestionAnswerConfiguration(answer: "500 grams", explanation: nil, correct: true)]),
//                CurrencyDragQuestionConfiguration(fromValue: 23, fromCurrency: "EUR", toValue: 621, toCurrency: "CZK", tolerance: 100, fromNotes: [CurrencyDragQuestionConfigurationNote(value: 10, currency: "EUR"), CurrencyDragQuestionConfigurationNote(value: 10, currency: "EUR"), CurrencyDragQuestionConfigurationNote(value: 1, currency: "EUR"), CurrencyDragQuestionConfigurationNote(value: 1, currency: "EUR"), CurrencyDragQuestionConfigurationNote(value: 1, currency: "EUR")], correctNotes: [CurrencyDragQuestionConfigurationNote(value: 500, currency: "CZK"), CurrencyDragQuestionConfigurationNote(value: 100, currency: "CZK"), CurrencyDragQuestionConfigurationNote(value: 10, currency: "CZK"), CurrencyDragQuestionConfigurationNote(value: 10, currency: "CZK"), CurrencyDragQuestionConfigurationNote(value: 1, currency: "CZK")], availableNotes: [(note: CurrencyDragQuestionConfigurationNote(value: 1, currency: "CZK"), count: 5), (note: CurrencyDragQuestionConfigurationNote(value: 10, currency: "CZK"), count: 2), (note: CurrencyDragQuestionConfigurationNote(value: 100, currency: "CZK"), count: 5), (note: CurrencyDragQuestionConfigurationNote(value: 500, currency: "CZK"), count: 1)], hint: ScaleHint(topUnit: "EUR", topMin: 0, topMax: 1.11, bottomUnit: "CZK", bottomMin: 0, bottomMax: 30)),
//                ScaleQuestionConfiguration(question: "How many MILES is 10 KILOMETRES?", scaleMin: 10.0, scaleMax: 23.0, correctValue: 18.21, correctTolerance: 1.0, toUnit: "Miles")
//            ])
//
//        let configArea = TaskConfiguration(taskRunId: "2", questions: [
//                NumericQuestionConfiguration(fromValue: 8, fromUnit: "km²", toValue: 800, toUnit: "ha (hectare)", minCorrectValue: 750, maxCorrectValue: 850, image: nil, hint: NumericHint(text: "1 km² is 100 ha")),
//                ScaleQuestionConfiguration(question: "Convert 10 km² to mi² (miles squared)", scaleMin: 0, scaleMax: 22, correctValue: 3.86, correctTolerance: 1.0, toUnit: "km²"),
//                NumericQuestionConfiguration(fromValue: 4, fromUnit: "football fields", toValue: 24000, toUnit: "m²", minCorrectValue: 16000, maxCorrectValue: 40000, image: UIImage(named: "field")!, hint: NumericHint(text: "1 football field is approx. from 4000 to 10000 m²")),
//                SortQuestionConfiguration(question: "Sort from smallest to largest", topDescription: "smallest", bottomDescription: "largest", questions: [
//                        SortQuestionItem(title: "100 m²", correctPosition: 1, presentedPosition: 2, errorExplanation: ""),
//                        SortQuestionItem(title: "1 ha", correctPosition: 2, presentedPosition: 1, errorExplanation: ""),
//                        SortQuestionItem(title: "1000 in²", correctPosition: 0, presentedPosition: 3, errorExplanation: "1000 in² 0.65 m²"),
//                        SortQuestionItem(title: "50 mi²", correctPosition: 3, presentedPosition: 0, errorExplanation: "50 mi² = 130 km²")
//                ]),
//                ClosedEndedQuestionConfiguration(question: "What's shorter?", answers: [ClosedEndedQuestionAnswerConfiguration(answer: "1 mile", explanation: nil, correct: false), ClosedEndedQuestionAnswerConfiguration(answer: "1 km", explanation: "1 km = 0.62 mile", correct: true)]),
//                NumericQuestionConfiguration(fromValue: 3, fromUnit: "yd²", toValue: 27, toUnit: "ft²", minCorrectValue: 25, maxCorrectValue: 30, image: nil, hint: NumericHint(text: "1 yd² = 9 ft²")),
//                ScaleQuestionConfiguration(question: "Convert 23 m² to ft²", scaleMin: 120, scaleMax: 340, correctValue: 248, correctTolerance: 20, toUnit: "ft²"),
//        ])
//        
//        if task.category == TaskCategory.Area {
//            callback(configArea)
//        } else {
//            callback(config)
//        }
}