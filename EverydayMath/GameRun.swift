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
    func gameRun(gameRun: protocol<GameRun, QuestionBased>, showQuestion question: Question, index: Int)
    func gameRun(gameRun: protocol<GameRun, QuestionBased>, questionCompleted question: Question, index: Int, result: QuestionResult)
    func gameRun(gameRun: protocol<GameRun, QuestionBased>, questionGaveSecondTry question: Question, index: Int)
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

protocol QuestionBased {
    var questions: [Question] { get }
    var currentQuestionIndex: Int? { get }
    
    func nextQuestion()
}

class DefaultGameRun: GameRun, QuestionBased, QuestionDelegate {
    let game: Game
    let config: GameConfiguration
    let questions: [Question]
    let log: GameRunLog
    
    var currentQuestionIndex: Int?
    var currentQuestionPresentationDate: NSDate?
    var currentQuestionSecondTry = false
    
    var delegate: GameRunDelegate?
    
    var running = false
    var finished = false {
        didSet(value) {
            if value {
                running = false
            }
        }
    }
    
    init(game: Game, config: GameConfiguration) {
        self.game = game
        self.config = config
        self.questions = config.questions.flatMap(QuestionFactory.questionForConfiguration)
        self.log = GameRunLog(gameRunId: config.gameRunId)
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
        abortGameRun()
    }
    
    func nextQuestion() {
        let index = currentQuestionIndex != nil ? currentQuestionIndex! + 1 : 0
        
        if var nextQuestion = questions[safe: index] {
            nextQuestion.delegate = self
            delegate?.gameRun(self, showQuestion: nextQuestion, index: index)
            currentQuestionIndex = index
            currentQuestionPresentationDate = NSDate()
            currentQuestionSecondTry = false
        } else {
            finishGameRun()
        }
    }
    
    private func abortGameRun() {
        finished = true
        delegate?.gameRunAborted(self)
        
        self.log.aborted = true
        APIClient.uploadGameRunLog(self.log, callback: nil)
    }
    
    private func finishGameRun() {
        finished = true
        delegate?.gameRunCompleted(self)
        
        APIClient.uploadGameRunLog(self.log, callback: nil)        
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
            case 0...question.properties.fastTime:
                result = QuestionResult.CorrectFast
            case question.properties.fastTime...question.properties.neutralTime:
                result = QuestionResult.CorrectNeutral
            default:
                result = QuestionResult.CorrectSlow
            }
        } else {
            result = QuestionResult.Incorrect
        }
        
        let taskLog = QuestionRunLog(questionId: question.properties.questionId, correct: correct, time: timeSpend, hintShown: currentQuestionSecondTry, answer: answer)
        log.appendQuestionLog(taskLog)

        delegate?.gameRun(self, questionCompleted: question, index: index, result: result)
    }
    
    func questionGaveSecondTry(question: Question) {
        guard let index = questions.indexOf(question) else {
            assertionFailure("task was not found")
            return
        }
        
        currentQuestionSecondTry = true
        delegate?.gameRun(self, questionGaveSecondTry: question, index: index)
    }
}