//
//  TaskConfiguration.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 02.03.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation
import Unbox

struct TaskConfiguration: Unboxable {
    var taskRunId: Int
    var showSpeedFeedback: Bool
    var questions: [QuestionConfiguration]
    
    init(unboxer: Unboxer) {
        self.taskRunId = unboxer.unbox("id")
        self.showSpeedFeedback = unboxer.unbox("speedFeedback")
        self.questions = unboxer.unbox("questions")
    }
}