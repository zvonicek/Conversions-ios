//
//  GameConfiguration.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation
import Unbox

/// Implemented by question configurations allowing an image to be shown
protocol ImageQuestionConfiguration: class {
    var imagePath: String? { get }
    var image: UIImage? { get set }
}

/// Implemented by question configurations allowing a hint to be shown
protocol HintQuestionConfiguration: class {
    var hint: HintConfiguration? { get }
}

typealias SimpleResult = (title: String?, value: String)
/// Implemented by question configurations that makes it possible to summarize its result into "title" and "value"
protocol SimpleResultConfiguration {
    func to() -> SimpleResult
} 

/// Holds configuration of the question received from the backend
class QuestionConfiguration: Unboxable {
    var questionId: Int
    var targetTime: NSTimeInterval?
    
    required init(unboxer: Unboxer) {
        questionId = unboxer.unbox("id")
        targetTime = unboxer.unbox("targetTime")
    }
}

/// Types of the question configurations received from the backend
enum QuestionConfigurationType: String {
    case CloseEnded = "questionCloseEnded"
    case Numeric = "questionNumeric"
    case Scale = "questionScale"
    case Sort = "questionSort"
    case Currency = "questionCurrency"
    
    static func unbox(dict: UnboxableDictionary) -> QuestionConfiguration? {
        guard let typeString = dict["type"] as? String, let type = QuestionConfigurationType(rawValue: typeString)
            else { return nil }
        
        switch type {
        case .CloseEnded:
            let q: ClosedEndedQuestionConfiguration? = Unbox(dict)
            return q
        case .Numeric:
            let q: NumericQuestionConfiguration? = Unbox(dict)
            return q
        case .Scale:
            let q: ScaleQuestionConfiguration? = Unbox(dict)
            return q
        case .Sort:
            let q: SortQuestionConfiguration? = Unbox(dict)
            return q
        case .Currency:
            let q: CurrencyDragQuestionConfiguration? = Unbox(dict)
            return q
        }
    }
}

extension Unboxer {
    func unbox(key: String) -> [QuestionConfiguration] {
        guard let questions = self.dictionary[key] as? [UnboxableDictionary]
            else { return [] }
        
        return questions.flatMap({ (dict) -> QuestionConfiguration? in
            return QuestionConfigurationType.unbox(dict)
        })
    }
}