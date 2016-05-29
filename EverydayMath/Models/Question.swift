//
//  Question.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

/// Delegate to inform TaskRun about question progress
protocol QuestionDelegate {
    func questionCompleted(question: Question, correct: Bool, accuracy: QuestionResultAccuracy?, answer: [String: AnyObject])
    func questionGaveSecondTry(question: Question)
}

/// Protocol implemented by each question
protocol Question {
    var delegate: QuestionDelegate? { get set }
    
    func config() -> QuestionConfiguration
    func identifier() -> String
    func getView() -> UIView
}

extension CollectionType where Generator.Element == Question {
    func indexOf(element: Generator.Element) -> Index? {
        return indexOf({ $0.identifier() == element.identifier() })
    }
}

/// Factory class for Question instances
class QuestionFactory {
    
    /**
     Returns Question for given QuestionConfiguration
     
     - parameter configuration: configuration to be created Question for
     
     - returns: question instance configured with the given configuration, or nil, when no appropriate question found
     */
    class func questionForConfiguration(configuration: QuestionConfiguration) -> Question? {
        if let configuration = configuration as? NumericQuestionConfiguration {
            return NumericQuestion(config: configuration)
        } else if let configuration = configuration as? ClosedEndedQuestionConfiguration {
            return ClosedEndedQuestion(config: configuration)
        } else if let configuration = configuration as? SortQuestionConfiguration {
            return SortQuestion(config: configuration)
        } else if let configuration = configuration as? ScaleQuestionConfiguration {
            return ScaleQuestion(config: configuration)
        } else if let configuration = configuration as? CurrencyDragQuestionConfiguration {
            return CurrencyDragQuestion(config: configuration)
        }
        
        return nil
    }
}