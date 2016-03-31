//
//  GameResult.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 18.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

typealias AnswerLog = [String: AnyObject]

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
    
    func serialize() -> [String: AnyObject] {
        return [
            "id": taskRunId,
            "aborted": aborted,
            "questions": questionResults.map { $0.serialize() }
        ]
    }
}
