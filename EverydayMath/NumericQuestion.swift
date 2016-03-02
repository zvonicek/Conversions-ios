//
//  NumericTaskConfiguration.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 30.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation
import Unbox

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
    
    func verifyResult(value: Float) -> Bool {
        if case configuration.minCorrectValue ... configuration.maxCorrectValue = value {
            return true
        } else {
            return false
        }
    }
    
    func identifier() -> String {
        return String(ObjectIdentifier(self).uintValue)
    }    
}

class NumericQuestionConfiguration: QuestionConfiguration {
    let fromValue: Float
    let fromUnit: String
    let toValue: Float
    let toUnit: String
    let minCorrectValue: Float
    let maxCorrectValue: Float
    let image: UIImage?
    
    let hint: HintConfiguration?
    
    required init(unboxer: Unboxer) {
        fromValue = unboxer.unbox("fromValue")
        fromUnit = unboxer.unbox("fromUnit")
        toValue = unboxer.unbox("toValue")
        toUnit = unboxer.unbox("toUnit")
        minCorrectValue = unboxer.unbox("minCorrectValue")
        maxCorrectValue = unboxer.unbox("maxCorrectValue")
        image = nil //unboxer.unbox("imagePath")
        hint = nil
        
        super.init(unboxer: unboxer)        
    }
}
