//
//  ClosedEndedTaskConfiguration.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 30.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation

class ClosedEndedTask: Task {
    var delegate: TaskDelegate?
    let configuration: ClosedEndedTaskConfiguration
    let properties: TaskProperties = TaskProperties(taskId: "B", fastTime: 5, neutralTime: 10)

    init(config: ClosedEndedTaskConfiguration) {
        configuration = config
    }
    
    func getView() -> UIView {
        let view = NumericTaskView.loadFromNibNamed("ClosedEndedTaskView") as! ClosedEndedTaskView
        view.task = self
        view.delegate = self.delegate
        return view
    }
    
    func identifier() -> String {
        return String(ObjectIdentifier(self).uintValue)
    }    
}

struct ClosedEndedTaskAnswerConfiguration: Equatable {
    let answer: String
    let explanation: String?
    let correct: Bool
}

func ==(lhs: ClosedEndedTaskAnswerConfiguration, rhs: ClosedEndedTaskAnswerConfiguration) -> Bool {
    return lhs.answer == rhs.answer
}

struct ClosedEndedTaskConfiguration: TaskConfiguration {
    let question: String
    let answers: [ClosedEndedTaskAnswerConfiguration]
    
    func correctAnswers() -> [ClosedEndedTaskAnswerConfiguration] {
        return answers.filter { $0.correct }
    }
}