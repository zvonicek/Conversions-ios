//
//  QuestionResult.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 18.03.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

enum QuestionResultAccuracy {
    case Imprecise, Precise, NonApplicable
}

enum QuestionResultSpeed {
    case Fast, Slow, NonApplicable
}

/// Result of the answered question to be shown in the app
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
            return ["That was really quick", "Great speed", "You're really quick"].randomItem()
        case .Correct(.Imprecise, .Slow), .Correct(.NonApplicable, .Slow), .Correct(.Imprecise, .NonApplicable), .Correct(.NonApplicable, .NonApplicable):
            return ["Good effort", "Fair enough", "Keep it up"].randomItem()
        case .Correct(.Precise, .Fast):
            return ["Quick and correct!", "Wow, quick and correct", "Quick and precise", "Great time and precision!"].randomItem()
        case .Correct(.Precise, .Slow):
            return ["Correct, try to be quicker", "Correct, but not so quick"].randomItem()
        case .Correct(.Precise, .NonApplicable):
            return ["Precise!", "That's correct", "Great precision", "That's it", "Keep it up", "That's right", "Excellent"].randomItem()
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
