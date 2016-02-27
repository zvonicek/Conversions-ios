//
//  GameResult.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 18.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

struct QuestionRunLog {
    var questionId: String
    var correct: Bool
    var time: NSTimeInterval
    var hintShown: Bool
    var answer: [String: AnyObject]
}

class TaskRunLog {
    var taskRunId: String
    var questionResults = [QuestionRunLog]()
    var userId: String
    var aborted = false
    var date = NSDate()
    
    init(taskRunId: String) {
        self.taskRunId = taskRunId
        self.userId = "foo"
    }
    
    func appendQuestionLog(log: QuestionRunLog) {
        questionResults.append(log)
    }
}
