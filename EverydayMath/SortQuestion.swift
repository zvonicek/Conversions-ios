//
//  SortQuestion.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 20.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

struct SortQuestionItem: QuestionConfiguration {
    let title: String
    let correctPosition: Int
    let presentedPosition: Int
    let errorExplanation: String
}

extension SortQuestionItem: Equatable {}

func ==(lhs: SortQuestionItem, rhs: SortQuestionItem) -> Bool {
    return lhs.title == rhs.title
}

struct SortQuestionConfiguration: QuestionConfiguration {
    let question: String
    let topDescription: String
    let bottomDescription: String
    let questions: [SortQuestionItem]
    
    func presentedQuestions() -> [SortQuestionItem] {
        return questions.sort({ $0.presentedPosition < $1.presentedPosition })
    }
    
    func correctQuestions() -> [SortQuestionItem] {
        return questions.sort({ $0.correctPosition < $1.correctPosition })
    }
}

class SortQuestion: Question {
    var delegate: QuestionDelegate?
    let configuration: SortQuestionConfiguration
    let properties: QuestionProperties = QuestionProperties(questionId: "E", fastTime: 5, neutralTime: 10)
    
    init(config: SortQuestionConfiguration) {
        configuration = config
    }
    
    func getView() -> UIView {
        let view = SortQuestionView.loadFromNibNamed("SortQuestionView") as! SortQuestionView
        view.question = self
        view.delegate = self.delegate
        return view
    }

    func identifier() -> String {
        return String(ObjectIdentifier(self).uintValue)
    }    
}
