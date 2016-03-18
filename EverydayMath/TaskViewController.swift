//
//  TaskViewController.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 08.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    var taskRun: TaskRun?
    
    @IBOutlet var topBar: TaskHeaderView!
    @IBOutlet var taskView: UIView!
    @IBOutlet var pauseView: UIView!
    
    var resultView: ResultView!
    
    lazy var dimView: UIView = {
        let view = UIView()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "continueGame")
        view.addGestureRecognizer(gestureRecognizer)
        return view
    }()
    
    var currentQuestionView: UIView? {
        willSet(questionView) {
            if let questionView = questionView {
                taskView.addSubview(questionView)
                
                // configure task view
                if let currentQuestionView = currentQuestionView {
                    questionView.frame = CGRectOffset(taskView.bounds, taskView.bounds.width, 0)
                    questionView.translatesAutoresizingMaskIntoConstraints = true
                    
                    // animate task transition
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        questionView.frame = self.taskView.bounds
                        currentQuestionView.frame = CGRectOffset(currentQuestionView.frame, -currentQuestionView.frame.size.width, 0)
                    }, completion: { (val: Bool) -> Void in
                        currentQuestionView.removeFromSuperview()
                    })
                } else {
                    questionView.frame = taskView.bounds
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
        
        if let taskRun = taskRun {
            topBar.progressView.components = taskRun.questions.count
        }
        taskRun?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if let taskRun = taskRun where !taskRun.finished {
            taskRun.start()
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
        taskRun?.abort()
        self.presentingViewController?.modalTransitionStyle = UIModalTransitionStyle.CoverVertical;
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// request to hide resutView
    @IBAction func continueGame() {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.resultView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.resultView.frame), CGRectGetHeight(self.resultView.frame))
            self.dimView.alpha = 0.0
        }) { (let completed) -> Void in
            self.resultView.removeFromSuperview()
            self.dimView.removeFromSuperview()
            
            if let taskRun = self.taskRun where self.resultView.finalResult {
                taskRun.nextQuestion()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destionation = segue.destinationViewController as? TaskCompletedViewController, let taskRun = sender as? TaskRun where segue.identifier == "completedSegue" {
            destionation.taskRun = taskRun
        }
    }
}

extension TaskViewController: TaskRunDelegate {
    // MARK: GameRunDelegate methods

    func taskRun(taskRun: TaskRun, showQuestion question: Question, index: Int) {
        currentQuestionView = question.getView()
        print("show view")
    }
    
    func taskRun(taskRun: TaskRun, questionCompleted question: Question, index: Int, result: QuestionResult) {
        var simpleResult: String?
        if let config = question.config() as? SimpleResultConfiguration {
            let res = config.to()
            simpleResult = String(format: "%@ %@", NSNumberFormatter.formatter.stringFromNumber(res.value)!, res.unit)
        }
        
        resultView = ResultView.instanceFromNib(simpleResult != nil)
        
        if result.correct() {
            resultView.setSuccessWithMessage(result.message(), result: simpleResult)
        } else {
            resultView.setFailureWithMessage(result.message(), subtitle: nil, result: simpleResult)
        }
        resultView.finalResult = true
        
        showResultView {
            self.topBar.progressView.updateStateForComponent(index, state: result.progressViewState())
        }
    }
    
    func taskRun(taskRun: TaskRun, questionGaveSecondTry task: Question, index: Int) {
        resultView = ResultView.instanceFromNib(false)
        resultView.setFailureWithMessage(NSLocalizedString("Try it again with hint", comment: "Try it again with hint"), subtitle: NSLocalizedString("Tap to try it again", comment: "Tap to try it again"), result: nil)
        resultView.finalResult = false
        showResultView {
            self.performSelector("continueGame", withObject: nil, afterDelay: 0.8)
        }
    }
    
    func taskRunCompleted(taskRun: TaskRun) {
        print("game completed")
        performSegueWithIdentifier("completedSegue", sender: taskRun)
    }
    
    func taskRunAborted(taskRun: TaskRun){
        print("game aborted")
    }

}
