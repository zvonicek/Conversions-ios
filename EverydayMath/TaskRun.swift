//
//  TaskRun.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 09.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation

// MARK: GameRun protocols
protocol TaskRunDelegate {
    func taskRun(taskRun: protocol<TaskRun, QuestionBased>, showQuestion question: Question, index: Int)
    func taskRun(taskRun: protocol<TaskRun, QuestionBased>, questionCompleted question: Question, index: Int, result: QuestionResult)
    func taskRun(taskRun: protocol<TaskRun, QuestionBased>, questionGaveSecondTry question: Question, index: Int)
    func taskRunCompleted(taskRun: TaskRun)
    func taskRunAborted(taskRun: TaskRun)
}

protocol TaskRun {
    var delegate: TaskRunDelegate? { get set }
    
    var running: Bool { get }
    var finished: Bool { get }
    
    func start()
    func pause()
    func resume()
}

protocol QuestionBased {
    var questions: [Question] { get }
    var currentQuestionIndex: Int? { get }
    
    func nextQuestion()
}

class DefaultTaskRun: TaskRun, QuestionBased, QuestionDelegate {
    let task: Task
    let config: TaskConfiguration
    let questions: [Question]
    let log: TaskRunLog
    
    var currentQuestionIndex: Int?
    var currentQuestionPresentationDate: NSDate?
    var currentQuestionSecondTry = false
    
    var delegate: TaskRunDelegate?
    
    var running = false
    var finished = false {
        didSet(value) {
            if value {
                running = false
            }
        }
    }
    
    init(task: Task, config: TaskConfiguration) {
        self.task = task
        self.config = config
        self.questions = config.questions.flatMap(QuestionFactory.questionForConfiguration)
        self.log = TaskRunLog(taskRunId: config.taskRunId)
    }
    
    func start() {
        running = true
        nextQuestion()
    }
    
    func pause() {
        running = false
    }
    
    func resume() {
        running = true
    }
    
    func abort() {
        abortTaskRun()
    }
    
    func nextQuestion() {
        let index = currentQuestionIndex != nil ? currentQuestionIndex! + 1 : 0
        
        if var nextQuestion = questions[safe: index] {
            nextQuestion.delegate = self
            delegate?.taskRun(self, showQuestion: nextQuestion, index: index)
            currentQuestionIndex = index
            currentQuestionPresentationDate = NSDate()
            currentQuestionSecondTry = false
        } else {
            finishTaskRun()
        }
    }
    
    private func abortTaskRun() {
        finished = true
        delegate?.taskRunAborted(self)
        
        self.log.aborted = true
        APIClient.uploadTaskRunLog(self.log, callback: nil)
    }
    
    private func finishTaskRun() {
        finished = true
        delegate?.taskRunCompleted(self)
        
        APIClient.uploadTaskRunLog(self.log, callback: nil)
    }
    
    // MARK: TaskDelegate
    
    func questionCompleted(question: Question, correct: Bool, answer: [String: AnyObject]) {
        guard let index = questions.indexOf(question) else {
            assertionFailure("task was not found")
            return
        }
        
        guard let currentQuestionPresentationDate = currentQuestionPresentationDate else {
            assertionFailure("task presentation date not found")
            return
        }
        
        let timeSpend = NSDate().timeIntervalSinceDate(currentQuestionPresentationDate)
        
        var result: QuestionResult
        if correct {
            switch timeSpend {
            case 0...question.config().fastTime:
                result = QuestionResult.CorrectFast
            case question.config().fastTime...question.config().neutralTime:
                result = QuestionResult.CorrectNeutral
            default:
                result = QuestionResult.CorrectSlow
            }
        } else {
            result = QuestionResult.Incorrect
        }
        
        let taskLog = QuestionRunLog(questionId: question.config().questionId, correct: correct, time: timeSpend, hintShown: currentQuestionSecondTry, answer: answer)
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