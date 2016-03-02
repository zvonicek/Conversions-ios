//
//  Question.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

enum QuestionResult {
    case Incorrect, CorrectFast, CorrectNeutral, CorrectSlow
    
    func progressViewState() -> ProgressViewState {
        switch self {
        case .Incorrect:
            return ProgressViewState.Incorrect
        case .CorrectFast:
            return ProgressViewState.CorrectA
        case .CorrectNeutral:
            return ProgressViewState.CorrectB
        case .CorrectSlow:
            return ProgressViewState.CorrectC
        }
    }
    
    func message() -> String {
        switch self {
        case .Incorrect:
            return ["Oh, no!", "Maybe next time", "Bad luck", "That's not correct"].randomItem()
        case .CorrectFast:
            return ["That was fast!", "You rock!", "Wow, that was quick"].randomItem()
        case .CorrectNeutral:
            return ["You are correct!", "That's correct", "Good effort", "Nice"].randomItem()
        case .CorrectSlow:
            return ["Try to be faster", "You can do faster"].randomItem()
        }
    }
    
    func correct() -> Bool {
        return self != .Incorrect
    }
}

protocol QuestionDelegate {
    func questionCompleted(question: Question, correct: Bool, answer: [String: AnyObject])
    func questionGaveSecondTry(question: Question)
}

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

class QuestionFactory {
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