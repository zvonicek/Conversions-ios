//
//  TaskCompletedViewController.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 03.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class TaskCompletedViewController: UIViewController {

    var taskRun: TaskRun?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        if let taskRun = taskRun {
            let result = TaskRunResult.createFromRunLog(taskRun.log.questionResults)
            let message = result.message()
            titleLabel.text = message.title
            subtitleLabel.text = message.subtitle
        }
    }
    
    @IBAction func dismiss() {
        self.presentingViewController?.presentingViewController?.modalTransitionStyle = UIModalTransitionStyle.CoverVertical;
        self.presentingViewController?.presentingViewController?.presentingViewController?.modalTransitionStyle = UIModalTransitionStyle.CoverVertical;
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
