//
//  GameViewController.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 08.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var gameRun: GameRun?
    
    @IBOutlet var topBar: GameHeaderView!
    @IBOutlet var gameView: UIView!
    @IBOutlet var resultView: ResultView!
    @IBOutlet var pauseView: UIView!
    
    lazy var dimView: UIView = {
        let view = UIView()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "continueGame")
        view.addGestureRecognizer(gestureRecognizer)
        return view
    }()
    
    var currentQuestionView: UIView? {
        willSet(questionView) {
            if let questionView = questionView {
                gameView.addSubview(questionView)
                
                // configure task view
                if let currentQuestionView = currentQuestionView {
                    questionView.frame = CGRectOffset(gameView.bounds, gameView.bounds.width, 0)
                    questionView.translatesAutoresizingMaskIntoConstraints = true
                    
                    // animate task transition
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        questionView.frame = self.gameView.bounds
                        currentQuestionView.frame = CGRectOffset(currentQuestionView.frame, -currentQuestionView.frame.size.width, 0)
                    }, completion: { (val: Bool) -> Void in
                        currentQuestionView.removeFromSuperview()
                    })
                } else {
                    questionView.frame = gameView.bounds
                }
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dimView.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        dimView.alpha = 0.0
        
        if let gameRun = gameRun as? QuestionBased {
            topBar.progressView.components = gameRun.questions.count
        }
        gameRun?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if let gameRun = gameRun where !gameRun.finished {
            gameRun.start()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        dimView.frame = self.view.frame
        pauseView.frame = self.view.frame
    }
    
    @IBAction func pauseGame() {
        self.pauseView.alpha = 0.0
        self.view.addSubview(self.pauseView)
        UIView.animateWithDuration(0.2) { () -> Void in
            self.pauseView.alpha = 1.0
        }
    }
    
    @IBAction func unpauseGame() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.pauseView.alpha = 0.0
            }) { _ -> Void in
                self.pauseView.removeFromSuperview()
        }
    }
    
    @IBAction func exitGame() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// request to hide resutView
    @IBAction func continueGame() {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.resultView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.resultView.frame), CGRectGetHeight(self.resultView.frame))
            self.dimView.alpha = 0.0
        }) { (let completed) -> Void in
            self.resultView.removeFromSuperview()
            self.dimView.removeFromSuperview()
            
            if let gameRun = self.gameRun as? QuestionBased where self.resultView.finalResult {
                gameRun.nextQuestion()
            }
        }
    }
    
    /// request to show resultView
    func showResultView(completionHandler: (Void -> Void)?) {
        self.view.addSubview(dimView)
        
        resultView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), self.view.frame.size.width, CGRectGetHeight(resultView.frame))
        self.view.addSubview(resultView)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.resultView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.resultView.frame), self.view.frame.size.width, CGRectGetHeight(self.resultView.frame))
            self.dimView.alpha = 1.0
            }) { _ -> Void in
                if let completionHandler = completionHandler {
                    completionHandler()
                }
        }
    }
}

extension GameViewController: GameRunDelegate {
    // MARK: GameRunDelegate methods
    
    func gameRun(gameRun: protocol<GameRun, QuestionBased>, showQuestion question: Question, index: Int) {
        currentQuestionView = question.getView()
        print("show view")
    }
    
    func gameRun(gameRun: protocol<GameRun, QuestionBased>, questionCompleted question: Question, index: Int, result: QuestionResult) {
        if result.correct() {
            resultView.setSuccessWithMessage(result.message())
        } else {
            resultView.setFailureWithMessage(result.message(), subtitle: nil)
        }
        resultView.finalResult = true
        
        showResultView {
            self.topBar.progressView.updateStateForComponent(index, state: result.progressViewState())
        }
    }
    
    func gameRun(gameRun: protocol<GameRun, QuestionBased>, questionGaveSecondTry task: Question, index: Int) {
        resultView.setFailureWithMessage(NSLocalizedString("Try it again with hint", comment: "Try it again with hint"), subtitle: NSLocalizedString("Tap to try it again", comment: "Tap to try it again"))
        resultView.finalResult = false
        showResultView {
            self.performSelector("continueGame", withObject: nil, afterDelay: 0.8)
        }
    }
    
    func gameRunCompleted(gameRun: GameRun) {
        print("game completed")
        performSegueWithIdentifier("completedSegue", sender: self)
    }
    
    func gameRunAborted(gameRun: GameRun){
        print("game aborted")
    }

}
