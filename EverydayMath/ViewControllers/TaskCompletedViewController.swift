//
//  TaskCompletedViewController.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 03.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit
import PromiseKit

class TaskCompletedViewController: UIViewController {

    var taskRun: TaskRun?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        if let taskRun = taskRun {
            let result = TaskRunResult.createFromRunLog(taskRun.log)
            let message = result.message()
            titleLabel.text = message.title
            subtitleLabel.text = message.subtitle
        }
        
    }
    
    @IBAction func playAgain() {
        playAgainButton.setTitle("Loading", forState: UIControlState.Normal)
        playAgainButton.enabled = false
        
        firstly {
            return self.taskRun!.logUploadPromise ?? Promise()
        }.then {
            return APIClient.getConfigurationForTask(self.taskRun!.task)
        }.then { taskConfiguration -> Void in
            if let presenting = self.presentingViewController as? TaskViewController, task = self.taskRun?.task {
                presenting.taskRun = task.run(taskConfiguration)
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.dismiss()
            }
        }.error { error in
            let alert = UIAlertController.alertControllerWithError(error as NSError, handler: { action -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func dismiss() {
        self.presentingViewController?.presentingViewController?.modalTransitionStyle = UIModalTransitionStyle.CoverVertical;
        self.presentingViewController?.presentingViewController?.presentingViewController?.modalTransitionStyle = UIModalTransitionStyle.CoverVertical;
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
