//
//  Question.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

enum QuestionResultAccuracy {
    case Imprecise, Precise, NonApplicable
}

enum QuestionResultSpeed {
    case Fast, Slow, NonApplicable
}

enum QuestionResult {
    case Incorrect, Correct(QuestionResultAccuracy, QuestionResultSpeed)
    
    func progressViewState() -> ProgressViewState {
        switch self {
        case .Incorrect:
            return ProgressViewState.Incorrect
        case .Correct(.Imprecise, .Fast), .Correct(.Precise, .Slow), .Correct(.NonApplicable, .Slow), .Correct(.Imprecise, .NonApplicable):
            return ProgressViewState.CorrectB
        case .Correct(.Imprecise, .Slow):
            return ProgressViewState.CorrectC
        case .Correct(.Precise, .Fast), .Correct(.NonApplicable, .Fast), .Correct(.Precise, .NonApplicable), .Correct(.NonApplicable, .NonApplicable):
            return ProgressViewState.CorrectA
        }
    }
    
    func message() -> String {
        switch self {
        case .Incorrect:
            return ["Oh, no!", "Maybe next time", "Bad luck", "That's not correct"].randomItem()
        case .Correct(.Imprecise, .Fast), .Correct(.NonApplicable, .Fast):
            return ["That was really fast", "Great speed", "You're really fast"].randomItem()
        case .Correct(.Imprecise, .Slow), .Correct(.NonApplicable, .Slow), .Correct(.Imprecise, .NonApplicable), .Correct(.NonApplicable, .NonApplicable):
            return ["Good effort", "Fair enough"].randomItem()
        case .Correct(.Precise, .Fast):
            return ["Fast and correct!", "Wow, quick and correct", "Quick and precise", "Great time and precision!"].randomItem()
        case .Correct(.Precise, .Slow):
            return ["Correct, try to be faster", "Correct, but not so fast"].randomItem()
        case .Correct(.Precise, .NonApplicable):
            return ["Precise!", "That's correct", "Great precision", "That's exactly it"].randomItem()
        }
    }
    
    func correct() -> Bool {
        switch self {
        case .Incorrect:
            return false
        default:
            return true
        }
    }
}

protocol QuestionDelegate {
    func questionCompleted(question: Question, correct: Bool, accuracy: QuestionResultAccuracy?, answer: [String: AnyObject])
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