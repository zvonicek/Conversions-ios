//
//  GameResult.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 18.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

struct TaskResultRecord {
    var taskId: String
    var correct: Bool
    var time: NSTimeInterval
    var hintShown: Bool
    var answer: [String: String]
}

struct GameResultRecord {
    var gameRunId: String
    var taskResults: [TaskResultRecord]
}
