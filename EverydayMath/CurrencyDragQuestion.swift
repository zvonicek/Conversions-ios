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

class CurrencyDragQuestionConfiguration: QuestionConfiguration {
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
        hint = nil
        
        super.init(unboxer: unboxer)        
    }
}