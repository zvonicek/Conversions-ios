//
//  NumericTaskConfiguration.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 30.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation
import Unbox

/// Numeric question initialized with a specific conifugration
class NumericQuestion: Question {
    var delegate: QuestionDelegate?
    let configuration: NumericQuestionConfiguration
    
    init(config: NumericQuestionConfiguration) {
        configuration = config
    }
    
    func config() -> QuestionConfiguration {
        return configuration
    }
    
    func getView() -> UIView {
        let view = self.configuration.image == nil ? NumericQuestionView.loadFromNibNamed("NumericQuestionView") as! NumericQuestionView : NumericQuestionView.loadFromNibNamed("NumericQuestionView", index: 1) as! NumericQuestionView
        view.question = self
        view.delegate = self.delegate
        return view
    }
    
    /**
     Verifies if the given answer is considered as correct (including tolerance interval)
     
     - parameter value: answer to be verified
     
     - returns: true if answer is correct, else false
     */
    func verifyResult(value: Float) -> Bool {
        // 'if case' cannot be rewritten to one-line bool expression :-(
        if case configuration.minCorrectValue ... configuration.maxCorrectValue = value {
            return true
        } else {
            return false
        }
    }
    
    /**
     Checks if the given answer is considered as precise
     
     - parameter value: answer to be checked
     
     - returns: true if answer is precise, else false
     */
    func isPrecise(value: Float) -> Bool {
        return value  == configuration.toValue || value == floorf(configuration.toValue) || value == ceilf(configuration.toValue)
    }
    
    func answerLogForAnswer(answer: String) -> AnswerLog {
        return ["answer": answer, "correctAnswer": configuration.toValue, "tolerance": configuration.tolerance]
    }
    
    func identifier() -> String {
        return String(ObjectIdentifier(self).uintValue)
    }    
}

/// Configuration of the numeric question
class NumericQuestionConfiguration: QuestionConfiguration, SimpleResultConfiguration, ImageQuestionConfiguration, HintQuestionConfiguration {
    let fromValue: Float
    let fromUnit: String
    let toValue: Float
    let toUnit: String
    let tolerance: Float
    let minCorrectValue: Float
    let maxCorrectValue: Float
    var image: UIImage?
    let imagePath: String?
    
    let hint: HintConfiguration?
    
    required init(unboxer: Unboxer) {
        fromValue = unboxer.unbox("fromValue")
        fromUnit = unboxer.unbox("fromUnit")
        toValue = unboxer.unbox("toValue")
        toUnit = unboxer.unbox("toUnit")
        tolerance = unboxer.unbox("tolerance")
        imagePath = unboxer.unbox("imagePath")
        hint = unboxer.unbox("hint")
        
        self.minCorrectValue = self.toValue - self.tolerance
        self.maxCorrectValue = self.toValue + self.tolerance
        
        super.init(unboxer: unboxer)        
    }
    
    func to() -> SimpleResult {
        return (nil, String(format: "%@ %@", NSNumberFormatter.formatter.stringFromNumber(toValue)!, toUnit))
    }
}
