//
//  GameRun.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 09.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation

// MARK: GameRun protocols
protocol GameRunDelegate {
    func gameRun(gameRun: protocol<GameRun, TaskBased>, showTask task: Task, index: Int)
    func gameRun(gameRun: protocol<GameRun, TaskBased>, taskCompleted task: Task, index: Int, result: TaskResult)
    func gameRunCompleted(gameRun: GameRun)
    func gameRunAborted(gameRun: GameRun)
}

protocol GameRun {
    var delegate: GameRunDelegate? { get set }
    
    var running: Bool { get }
    var finished: Bool { get }
    
    func start()
    func pause()
    func resume()
}

protocol TaskBased {
    var tasks: [Task] { get }
    var currentTaskIndex: Int? { get }
    
    func nextTask()
}

class DefaultGameRun: GameRun, TaskBased, TaskDelegate {
    let game: Game
    let config: GameConfiguration
    
    let tasks: [Task]
    var currentTaskIndex: Int?
    var currentTaskPresentationDate: NSDate?
    
    var delegate: GameRunDelegate?
    
    var running = false
    var finished = false {
        didSet(value) {
            if value {
                running = false
            }
        }
    }
    
    init(game: Game, config: TimeBasedGameConfiguration) {
        self.game = game
        self.config = config
        
        self.tasks = config.tasks.flatMap(TaskFactory.taskForConfiguration)
    }
    
    func start() {
        running = true
        nextTask()
    }
    
    func pause() {
        running = false
    }
    
    func resume() {
        running = true
    }
    
    func abort() {
        abortGameRun()
    }
    
    func nextTask() {
        let index = currentTaskIndex != nil ? currentTaskIndex! + 1 : 0
        
        if var nextTask = tasks[safe: index] {
            nextTask.delegate = self
            delegate?.gameRun(self, showTask: nextTask, index: index)
            currentTaskIndex = index
            currentTaskPresentationDate = NSDate()
        } else {
            finishGameRun()
        }
    }
    
    private func abortGameRun() {
        finished = true
        delegate?.gameRunAborted(self)
    }
    
    private func finishGameRun() {
        finished = true
        delegate?.gameRunCompleted(self)
    }
    
    // MARK: TaskDelegate
    
    func taskCompleted(task: Task, correct: Bool) {
        guard let index = tasks.indexOf(task) else {
            assertionFailure("task was not found")
            return
        }
        
        guard let currentTaskPresentationDate = currentTaskPresentationDate else {
            assertionFailure("task presentation date not found")
            return
        }
        
        var result: TaskResult
        if correct {
            let timeSpend = NSDate().timeIntervalSinceDate(currentTaskPresentationDate)
            switch timeSpend {
            case 0...task.properties.fastTime:
                result = TaskResult.CorrectFast
            case task.properties.fastTime...task.properties.neutralTime:
                result = TaskResult.CorrectNeutral
            default:
                result = TaskResult.CorrectSlow
            }
        } else {
            result = TaskResult.Incorrect
        }
        
        delegate?.gameRun(self, taskCompleted: task, index: index, result: result)
    }
}