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
    
    var currentTaskView: UIView? {
        willSet(taskView) {
            if let taskView = taskView {
                gameView.addSubview(taskView)
                
                if let currentTaskView = currentTaskView {
                    taskView.frame = CGRectOffset(gameView.bounds, gameView.bounds.width, 0)
                    taskView.translatesAutoresizingMaskIntoConstraints = true
                    
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        taskView.frame = self.gameView.bounds
                        currentTaskView.frame = CGRectOffset(currentTaskView.frame, -currentTaskView.frame.size.width, 0)
                    }, completion: { (val: Bool) -> Void in
                        currentTaskView.removeFromSuperview()
                    })
                } else {
                    taskView.frame = gameView.bounds
                }
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                    
        gameRun?.delegate = self        
    }
    
    override func viewWillAppear(animated: Bool) {
        if let gameRun = gameRun where !gameRun.finished {
            gameRun.start()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @IBAction func pauseGame() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension GameViewController: GameRunDelegate {
    // MARK: GameRunDelegate methods
    
    func gameRun(gameRun: protocol<GameRun, TaskBased>, showTask task: Task, index: Int) {
        let progress = Float(Float(index) / Float(gameRun.tasks.count))
        topBar.progressView.setProgress(progress, animated: true)
        currentTaskView = task.getView()
        
        print("show view")
    }

    func gameRun(gameRun: protocol<GameRun, TimeBased>, timerTick time: NSTimeInterval) {
        let percentage = 1 - (gameRun.remainingTime / gameRun.totalTime)
        topBar.timer.updateProgress(CGFloat(percentage))
    }
    
    func gameRunCompleted(gameRun: GameRun){
        print("game completed")
        performSegueWithIdentifier("completedSegue", sender: self)
    }
    
    func gameRunTimeouted(gameRun: GameRun){
        print("game timeouted")
        performSegueWithIdentifier("timeOutSegue", sender: self)
    }
    
    func gameRunAborted(gameRun: GameRun){
        print("game aborted")
    }

}