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
}

struct SortTaskConfiguration: TaskConfiguration {
    let question: String
    let questions: [SortTaskItem]
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
