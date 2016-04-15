//
//  GameResult.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 18.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

typealias AnswerLog = [String: AnyObject]
typealias TaskRunSummary = (incorrectRatio: Float, slowRatio: Float, impreciseRatio: Float, preciseRatio: Float)

struct QuestionRunLog {
    var questionId: Int
    var result: QuestionResult
    var time: NSTimeInterval
    var hintShown: Bool
    var answer: [String: AnyObject]
    
    func serialize() -> AnswerLog {
        return [
            "id": questionId,
            "correct": result.correct(),
            "time": time,
            "hintShown": hintShown,
            "answer": answer
        ];
    }
}

class TaskRunLog {
    var taskRunId: Int
    var questionResults = [QuestionRunLog]()
    var aborted = false
    
    init(taskRunId: Int) {
        self.taskRunId = taskRunId
    }
    
    func appendQuestionLog(log: QuestionRunLog) {
        questionResults.append(log)
    }
    
    func taskRunSummary() -> TaskRunSummary {
        let correctQuestions = self.questionResults.filter { $0.result.correct() }

        if correctQuestions.count == 0 {
            return (1, 0, 0, 0)
        } else {
            let incorrectRatio = 1 - (Float(correctQuestions.count) / Float(self.questionResults.count))
            let slowRatio = Float(correctQuestions.filter { if case .Correct(_, .Slow) = $0.result { return true } else { return false }}.count) / Float(correctQuestions.count)
            let impreciseRatio = Float(correctQuestions.filter { if case .Correct(.Imprecise, _) = $0.result { return true } else { return false }}.count) / Float(correctQuestions.count)
            let preciseRatio = Float(correctQuestions.filter { if case .Correct(.Precise, _) = $0.result { return true } else { return false }}.count) / Float(correctQuestions.count)
            
            return (incorrectRatio, slowRatio, impreciseRatio, preciseRatio)
        }
    }
    
    func serialize() -> [String: AnyObject] {
        let summary = self.taskRunSummary()
        
        return [
            "id": taskRunId,
            "aborted": aborted,
            "questions": questionResults.map { $0.serialize() },
            "summary": ["incorrectRatio": summary.incorrectRatio, "slowRatio": summary.slowRatio, "impreciseRatio": summary.impreciseRatio, "preciseRatio": summary.preciseRatio]
        ]
    }
}
