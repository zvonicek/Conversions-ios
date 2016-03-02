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
}

class TaskRunLog {
    var taskRunId: Int
    var questionResults = [QuestionRunLog]()
    var userId: String
    var aborted = false
    var date = NSDate()
    
    init(taskRunId: Int) {
        self.taskRunId = taskRunId
        self.userId = "foo"
    }
    
    func appendQuestionLog(log: QuestionRunLog) {
        questionResults.append(log)
    }
}
