//
//  TaskRunConfiguration.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 02.03.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation
import Unbox

/// Holds configuration of the task run received from the backend
struct TaskRunConfiguration: Unboxable {
    var taskRunId: Int
    var showSpeedFeedback: Bool
    var questions: [QuestionConfiguration]
    
    init(unboxer: Unboxer) {
        self.taskRunId = unboxer.unbox("id")
        self.showSpeedFeedback = unboxer.unbox("speedFeedback")
        self.questions = unboxer.unbox("questions")
    }
}