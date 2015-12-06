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

class NumericTask: Task {
    var delegate: TaskDelegate?    
    let taskConfiguration: NumericTaskConfiguration
    
    init(config: NumericTaskConfiguration) {
        taskConfiguration = config
    }
    
    func getView() -> UIView {
        let view = NumericTaskView.loadFromNibNamed("NumericTaskView") as! NumericTaskView
        view.task = self
        view.delegate = self.delegate
        return view
    }
    
    func verifyResult(value: Float) -> Bool {
        if case taskConfiguration.minCorrectValue ... taskConfiguration.maxCorrectValue = value {
            return true
        } else {
            return false
        }
    }
}

class ClosedEndedTask: Task {
    var delegate: TaskDelegate?
    let configuration: ClosedEndedTaskConfiguration
    
    init(config: ClosedEndedTaskConfiguration) {
        configuration = config
    }
    
    func getView() -> UIView {
        let view = NumericTaskView.loadFromNibNamed("ClosedEndedTaskView") as! ClosedEndedTaskView
        view.task = self
        view.delegate = self.delegate
        return view
    }
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