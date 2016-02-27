//
//  CurrencyDragQuestion.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 10.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

struct CurrencyDragQuestionConfigurationNote {
    let value: Float
    let currency: String
}

struct CurrencyDragQuestionConfiguration: QuestionConfiguration {
    let fromValue: Float
    let fromCurrency: String
    let toValue: Float
    let toCurrency: String
    let tolerance: Float
    let fromNotes: [CurrencyDragQuestionConfigurationNote] // may be removed
    let correctNotes: [CurrencyDragQuestionConfigurationNote]
    let availableNotes: [(note: CurrencyDragQuestionConfigurationNote, count: Int)]
    let hint: Hint?
}

class CurrencyDragQuestion: Question {
    var delegate: QuestionDelegate?
    let configuration: CurrencyDragQuestionConfiguration
    let properties = QuestionProperties(questionId: "A", fastTime: 5, neutralTime: 10)
    
    init(config: CurrencyDragQuestionConfiguration) {
        configuration = config
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