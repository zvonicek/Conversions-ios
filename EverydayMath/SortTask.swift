//
//  SortTask.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 20.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

struct SortTaskItem: TaskConfiguration {
    let title: String
    let correctPosition: Int
    let presentedPosition: Int
    let errorExplanation: String
}

extension SortTaskItem: Equatable {}

func ==(lhs: SortTaskItem, rhs: SortTaskItem) -> Bool {
    return lhs.title == rhs.title
}

struct SortTaskConfiguration: TaskConfiguration {
    let question: String
    let questions: [SortTaskItem]
    
    func presentedQuestions() -> [SortTaskItem] {
        return questions.sort({ $0.presentedPosition < $1.presentedPosition })
    }
    
    func correctQuestions() -> [SortTaskItem] {
        return questions.sort({ $0.correctPosition < $1.correctPosition })
    }
}

class SortTask: Task {
    var delegate: TaskDelegate?
    let configuration: SortTaskConfiguration
    
    init(config: SortTaskConfiguration) {
        configuration = config
    }
    
    func getView() -> UIView {
        let view = SortTaskView.loadFromNibNamed("SortTaskView") as! SortTaskView
        view.task = self
        view.delegate = self.delegate
        return view
    }

}
