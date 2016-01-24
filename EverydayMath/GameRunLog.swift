//
//  GameResult.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 18.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

struct TaskRunLog {
    var taskId: String
    var correct: Bool
    var time: NSTimeInterval
    var hintShown: Bool
    var answer: [String: AnyObject]
}

class GameRunLog {
    var gameRunId: String
    var taskResults = [TaskRunLog]()
    var userId: String
    var aborted = false
    var date = NSDate()
    
    init(gameRunId: String) {
        self.gameRunId = gameRunId
        self.userId = "foo"
    }
    
    func appendTaskLog(log: TaskRunLog) {
        taskResults.append(log)
    }
}
