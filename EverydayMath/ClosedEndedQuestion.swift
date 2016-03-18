//
//  ClosedEndedTaskConfiguration.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 30.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation
import Unbox

class ClosedEndedQuestion: Question {
    var delegate: QuestionDelegate?
    let configuration: ClosedEndedQuestionConfiguration

    init(config: ClosedEndedQuestionConfiguration) {
        configuration = config
    }
    
    func config() -> QuestionConfiguration {
        return configuration
    }
    
    func getView() -> UIView {
        let view = NumericQuestionView.loadFromNibNamed("ClosedEndedQuestionView") as! ClosedEndedQuestionView
        view.question = self
        view.delegate = self.delegate
        return view
    }
    
    func answerLogForAnswer(answer: String) -> AnswerLog {
        return ["answer": answer]
    }
    
    func identifier() -> String {
        return String(ObjectIdentifier(self).uintValue)
    }    
}

class ClosedEndedQuestionConfiguration: QuestionConfiguration {
    let question: String
    let image: UIImage?
    let answers: [ClosedEndedQuestionAnswerConfiguration]
    
    func correctAnswers() -> [ClosedEndedQuestionAnswerConfiguration] {
        return answers.filter { $0.correct }
    }
    
    required init(unboxer: Unboxer) {
        question = unboxer.unbox("question")
        answers = unboxer.unbox("answers")
        image = nil
        
        super.init(unboxer: unboxer)        
    }
}

struct ClosedEndedQuestionAnswerConfiguration: Equatable, Unboxable {
    let answer: String
    let explanation: String?
    let correct: Bool
    
    init(unboxer: Unboxer) {
        answer = unboxer.unbox("answer")
        explanation = unboxer.unbox("explanation")
        correct = unboxer.unbox("correct")
    }
}

func ==(lhs: ClosedEndedQuestionAnswerConfiguration, rhs: ClosedEndedQuestionAnswerConfiguration) -> Bool {
    return lhs.answer == rhs.answer
}