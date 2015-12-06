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
    func gameRun(gameRun: protocol<GameRun, TimeBased>, timerTick time: NSTimeInterval)
    func gameRunCompleted(gameRun: GameRun)
    func gameRunTimeouted(gameRun: GameRun)
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
}

protocol TimeBased {
    var totalTime: NSTimeInterval { get }
    var remainingTime: NSTimeInterval { get }
}


class TimedGameRun: GameRun, TaskBased, TimeBased, TaskDelegate {
    let game: Game
    let config: GameConfiguration
    
    let tasks: [Task]
    var currentTaskIndex: Int?
    
    let totalTime: NSTimeInterval
    var remainingTime: NSTimeInterval
    
    var delegate: GameRunDelegate?
    
    var timer = NSTimer()
    
    var running = false {
        didSet {
            timer.invalidate()
            if running {
                timer = NSTimer(timeInterval: 1.0, target: self, selector: "tick", userInfo: nil, repeats: true)
                NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
            } else {

            }
        }
    }
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
        self.totalTime = config.time
        self.remainingTime = config.time
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
    
    @objc func tick() {
        if remainingTime > 0 {
            remainingTime--
        } else {
            timer.invalidate()
            timeoutGameRn()
        }
        
        delegate?.gameRun(self, timerTick: remainingTime)
    }
    
    private func nextTask() {
        let index = currentTaskIndex != nil ? currentTaskIndex! + 1 : 0
        
        if var nextTask = tasks[safe: index] {
            nextTask.delegate = self
            delegate?.gameRun(self, showTask: nextTask, index: index)
            currentTaskIndex = index
        } else {
            finishGameRun()
        }
    }
    
    private func timeoutGameRn() {
        finished = true
        delegate?.gameRunTimeouted(self)
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
    
    func taskCompleted(task: Task) {
        self.nextTask()
    }
}