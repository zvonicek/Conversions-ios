//
//  TaskType.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

enum TaskType {
    case Numeric, ClosedOptions
}

protocol TaskDelegate {
    func taskCompleted(task: Task)
}

protocol Task {
    var delegate: TaskDelegate? { get set }
    
    func getView() -> UIView
}

class TaskFactory {
    class func taskForConfiguration(configuration: TaskConfiguration) -> Task? {
        if let configuration = configuration as? NumericTaskConfiguration {
            return NumericTask(config: configuration)
        } else if let configuration = configuration as? ClosedEndedTaskConfiguration {
            return ClosedEndedTask(config: configuration)
        }
        
        return nil
    }
}