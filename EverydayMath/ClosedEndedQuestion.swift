//
//  ClosedEndedTaskConfiguration.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 30.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation

class ClosedEndedQuestion: Question {
    var delegate: QuestionDelegate?
    let configuration: ClosedEndedQuestionConfiguration
    let properties: QuestionProperties = QuestionProperties(questionId: "B", fastTime: 5, neutralTime: 10)

    init(config: ClosedEndedQuestionConfiguration) {
        configuration = config
    }
    
    func getView() -> UIView {
        let view = NumericQuestionView.loadFromNibNamed("ClosedEndedQuestionView") as! ClosedEndedQuestionView
        view.question = self
        view.delegate = self.delegate
        return view
    }
    
    func identifier() -> String {
        return String(ObjectIdentifier(self).uintValue)
    }    
}

struct ClosedEndedQuestionAnswerConfiguration: Equatable {
    let answer: String
    let explanation: String?
    let correct: Bool
}

func ==(lhs: ClosedEndedQuestionAnswerConfiguration, rhs: ClosedEndedQuestionAnswerConfiguration) -> Bool {
    return lhs.answer == rhs.answer
}

struct ClosedEndedQuestionConfiguration: QuestionConfiguration {
    let question: String
    let answers: [ClosedEndedQuestionAnswerConfiguration]
    
    func correctAnswers() -> [ClosedEndedQuestionAnswerConfiguration] {
        return answers.filter { $0.correct }
    }
}