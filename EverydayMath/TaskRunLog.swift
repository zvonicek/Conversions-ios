//
//  GameResult.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 18.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

struct QuestionRunLog {
    var questionId: Int
    var correct: Bool
    var time: NSTimeInterval
    var hintShown: Bool
    var answer: [String: AnyObject]
    
    func serialize() -> [String: AnyObject] {
        return [
            "id": questionId,
            "correct": correct,
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
