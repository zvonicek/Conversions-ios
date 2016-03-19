//
//  CurrencyDragQuestion.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 10.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation
import Unbox

class CurrencyDragQuestion: Question {
    var delegate: QuestionDelegate?
    let configuration: CurrencyDragQuestionConfiguration
    
    init(config: CurrencyDragQuestionConfiguration) {
        configuration = config
    }
    
    func config() -> QuestionConfiguration {
        return configuration
    }
    
    func getView() -> UIView {
        let view = SortQuestionView.loadFromNibNamed("CurrencyDragQuestionView") as! CurrencyDragQuestionView
        view.question = self
        view.delegate = self.delegate
        return view
    }
    
    func verifyResult(notesSum: Float) -> Bool {
        return (abs(notesSum - self.configuration.toValue) < self.configuration.tolerance)
    }
    
    func isPrecise(notesSum: Float) -> Bool {
        return (abs(notesSum - self.configuration.toValue) < self.configuration.tolerance / 2)
    }
    
    func answerLogForAnswer(answer: Float, notes: [String]) -> AnswerLog {
        return ["answer": String(answer), "notes": notes, "correctAnswer": configuration.toValue, "tolerance": configuration.tolerance]
    }
    
    func identifier() -> String {
        return String(ObjectIdentifier(self).uintValue)
    }
}

struct CurrencyDragQuestionConfigurationNote: Unboxable {
    let value: Float
    let currency: String
    var count: Int = 0
    
    init(unboxer: Unboxer) {
        value = unboxer.unbox("value")
        currency = unboxer.unbox("currency")
        if unboxer.dictionary.indexForKey("count") != nil {
            count = unboxer.unbox("count")
        }
    }
}

class CurrencyDragQuestionConfiguration: QuestionConfiguration, SimpleResultConfiguration {
    let fromValue: Float
    let fromCurrency: String
    let toValue: Float
    let toCurrency: String
    let tolerance: Float
    let correctNotes: [CurrencyDragQuestionConfigurationNote]
    let availableNotes: [CurrencyDragQuestionConfigurationNote]
    let hint: HintConfiguration?
    
    required init(unboxer: Unboxer) {
        fromValue = unboxer.unbox("fromValue")
        fromCurrency = unboxer.unbox("fromCurrency")
        toValue = unboxer.unbox("toValue")
        toCurrency = unboxer.unbox("toCurrency")
        tolerance = unboxer.unbox("tolerance")
        correctNotes = unboxer.unbox("correctNotes")
        availableNotes = unboxer.unbox("availableNotes")
        hint = unboxer.unbox("hint")
        
        super.init(unboxer: unboxer)        
    }
    
    func to() -> SimpleResult {
        return (nil, String(format: "%@ %@", NSNumberFormatter.formatter.stringFromNumber(toValue)!, toCurrency))
    }
}