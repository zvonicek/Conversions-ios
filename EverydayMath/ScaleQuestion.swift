//
//  ScaleQuestion.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation
import Unbox

class ScaleQuestion: Question {
    var delegate: QuestionDelegate?
    let configuration: ScaleQuestionConfiguration
    
    init(config: ScaleQuestionConfiguration) {
        configuration = config
    }
    
    func config() -> QuestionConfiguration {
        return configuration
    }
    
    func getView() -> UIView {
        let view = ScaleQuestionView.loadFromNibNamed("ScaleQuestionView") as! ScaleQuestionView
        view.delegate = self.delegate
        view.question = self
        return view
    }
    
    func answerLogForAnswer(answer: Float) -> AnswerLog {
        return ["answer": String(answer), "correctAnswer": String(configuration.correctValue), "tolerance": String(configuration.correctTolerance)]
    }
    
    func identifier() -> String {
        return String(ObjectIdentifier(self).uintValue)
    }
}

class ScaleQuestionConfiguration: QuestionConfiguration {
    var question: String
    var scaleMin: Float
    var scaleMax: Float
    var correctValue: Float
    var correctTolerance: Float
    var toUnit: String
    
    required init(unboxer: Unboxer) {
        question = unboxer.unbox("question")
        scaleMin = unboxer.unbox("scaleMin")
        scaleMax = unboxer.unbox("scaleMax")
        correctValue = unboxer.unbox("correctValue")
        correctTolerance = unboxer.unbox("correctTolerance")
        toUnit = unboxer.unbox("toUnit")
        
        super.init(unboxer: unboxer)
    }
}