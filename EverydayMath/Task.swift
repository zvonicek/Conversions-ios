//
//  TaskType.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

enum TaskResult {
    case Incorrect, CorrectFast, CorrectNeutral, CorrectSlow
    
    func progressViewState() -> ProgressViewState {
        switch self {
        case .Incorrect:
            return ProgressViewState.Incorrect
        case .CorrectFast:
            return ProgressViewState.CorrectA
        case .CorrectNeutral:
            return ProgressViewState.CorrectB
        case .CorrectSlow:
            return ProgressViewState.CorrectC
        }
    }
    
    func message() -> String {
        switch self {
        case .Incorrect:
            return ["Oh, no!", "Maybe next time", "Bad luck", "That's not correct"].randomItem()
        case .CorrectFast:
            return ["That was fast!", "You rock!", "Wow, that was quick"].randomItem()
        case .CorrectNeutral:
            return ["You are correct!", "That's correct", "Good effort", "Nice"].randomItem()
        case .CorrectSlow:
            return ["Try to be faster", "You can do faster"].randomItem()
        }
    }
    
    func correct() -> Bool {
        return self != .Incorrect
    }
}

protocol TaskDelegate {
    func taskCompleted(task: Task, correct: Bool, answer: [String: AnyObject])
    func taskGaveSecondTry(task: Task)
}

struct TaskProperties {
    var taskId: String
    var fastTime: NSTimeInterval
    var neutralTime: NSTimeInterval
}

protocol Task {
    var delegate: TaskDelegate? { get set }
    var properties: TaskProperties { get }
    
    func identifier() -> String
    func getView() -> UIView
}

extension CollectionType where Generator.Element == Task {
    func indexOf(element: Generator.Element) -> Index? {
        return indexOf({ $0.identifier() == element.identifier() })
    }
}

class TaskFactory {
    class func taskForConfiguration(configuration: TaskConfiguration) -> Task? {
        if let configuration = configuration as? NumericTaskConfiguration {
            return NumericTask(config: configuration)
        } else if let configuration = configuration as? ClosedEndedTaskConfiguration {
            return ClosedEndedTask(config: configuration)
        } else if let configuration = configuration as? SortTaskConfiguration {
            return SortTask(config: configuration)
        } else if let configuration = configuration as? ScaleTaskConfiguration {
            return ScaleTask(config: configuration)
        } else if let configuration = configuration as? CurrencyDragTaskConfiguration {
            return CurrencyDragTask(config: configuration)
        }
        
        return nil
    }
}