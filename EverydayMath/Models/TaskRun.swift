//
//  TaskRun.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 09.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation
import PromiseKit

/// Delegate to inform a view controller about task run progress
protocol TaskRunDelegate {
    func taskRun(taskRun: TaskRun, showQuestion question: Question, index: Int)
    func taskRun(taskRun: TaskRun, questionCompleted question: Question, index: Int, result: QuestionResult)
    func taskRun(taskRun: TaskRun, questionGaveSecondTry question: Question, index: Int)
    func taskRunCompleted(taskRun: TaskRun)
    func taskRunAborted(taskRun: TaskRun)
}

/// TaskRun class manages the whole practice run including navigation between questions 
class TaskRun {
    let task: Task
    let config: TaskRunConfiguration
    let questions: [Question]
    let log: TaskRunLog
    
    private var currentQuestionIndex: Int?
    private var currentQuestionPresentationDate: NSDate?
    private var currentQuestionSecondTry = false
    
    private var pausedDate: NSDate?
    private var pausedDuration = NSTimeInterval(0)
    
    private(set) var logUploadPromise: Promise<Void>?
    
    var delegate: TaskRunDelegate?
    
    private var running = false
    private(set) var finished = false {
        didSet(value) {
            if value {
                running = false
            }
        }
    }
    
    init(task: Task, config: TaskRunConfiguration) {
        self.task = task
        self.config = config
        self.questions = config.questions.flatMap(QuestionFactory.questionForConfiguration)
        self.log = TaskRunLog(taskRunId: config.taskRunId)
    }
    
    /**
     Start the practice of this task run
     */
    func start() {
        running = true
        nextQuestion()
    }
    
    /**
     Pause the practice
     */
    func pause() {
        running = false
        pausedDate = NSDate()
    }
    
    /**
     Resume form the paused state
     */
    func resume() {
        if let pausedDate = self.pausedDate {
            pausedDuration += NSDate().timeIntervalSinceDate(pausedDate)
        }
        
        running = true
    }
    
    /**
     Manually abort the practice
     */
    func abort() {
        abortTaskRun()
    }
    
    /**
     Go to the next question
     */
    func nextQuestion() {
        let index = currentQuestionIndex != nil ? currentQuestionIndex! + 1 : 0
        
        if var nextQuestion = questions[safe: index] {
            nextQuestion.delegate = self
            delegate?.taskRun(self, showQuestion: nextQuestion, index: index)
            currentQuestionIndex = index
            currentQuestionPresentationDate = NSDate()
            currentQuestionSecondTry = false
            pausedDuration = NSTimeInterval(0)
        } else {
            finishTaskRun()
        }
    }
    
    private func abortTaskRun() {
        self.log.aborted = true
        logUploadPromise = APIClient.uploadTaskRunLog(self.log)
        
        finished = true
        delegate?.taskRunAborted(self)
    }
    
    private func finishTaskRun() {
        self.log.aborted = false
        logUploadPromise = APIClient.uploadTaskRunLog(self.log)
        
        finished = true
        delegate?.taskRunCompleted(self)
    }
}

extension TaskRun: QuestionDelegate {
    func questionCompleted(question: Question, correct: Bool, accuracy: QuestionResultAccuracy?, answer: [String: AnyObject]) {
        guard let index = questions.indexOf(question) else {
            assertionFailure("task was not found")
            return
        }
        
        guard let currentQuestionPresentationDate = currentQuestionPresentationDate else {
            assertionFailure("task presentation date not found")
            return
        }
        
        // compute the time spend on the question
        let timeSpend = NSDate().timeIntervalSinceDate(currentQuestionPresentationDate) - pausedDuration
        
        // gather the question result
        var result: QuestionResult
        if let accuracy = accuracy where correct {
            var speed: QuestionResultSpeed
            if let targetTime = question.config().targetTime where self.config.showSpeedFeedback {
                switch timeSpend {
                case 0...targetTime:
                    speed = .Fast
                default:
                    speed = .Slow
                }
            } else {
                speed = .NonApplicable
            }
            
            result = QuestionResult.Correct(accuracy, speed)
        } else {
            result = QuestionResult.Incorrect
        }
        
        var answer = answer
        if let config = question.config() as? HintQuestionConfiguration where currentQuestionSecondTry {
            answer["hintType"] = config.hint?.description()
        }
        
        // create the question log
        let taskLog = QuestionRunLog(questionId: question.config().questionId, result: result, time: timeSpend, hintShown: currentQuestionSecondTry, answer: answer)
        log.appendQuestionLog(taskLog)

        delegate?.taskRun(self, questionCompleted: question, index: index, result: result)
    }
    
    func questionGaveSecondTry(question: Question) {
        guard let index = questions.indexOf(question) else {
            assertionFailure("task was not found")
            return
        }
        
        currentQuestionSecondTry = true
        delegate?.taskRun(self, questionGaveSecondTry: question, index: index)
    }
}