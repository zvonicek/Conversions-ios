//
//  LoadingViewController.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 08.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit
import Foundation

class LoadingViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    
    var task: Task?
    var config: TaskRunConfiguration?
    
    override func viewDidLoad() {
        assert(task != nil)
        
        self.nameLabel.text = "\(task!.category.description()) – \(task!.name)"
        startButton.setTitle("Loading", forState: UIControlState.Normal)
        startButton.enabled = false
        
        APIClient.getConfigurationForTask(self.task!).then { taskConfiguration in
            self.configurationLoaded(taskConfiguration)
        }.error { error in
            let alert = UIAlertController.alertControllerWithError(error as NSError, handler: { action -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func configurationLoaded(config: TaskRunConfiguration) {
        if config.questions.count > 0 {
            startButton.setTitle("Play", forState: UIControlState.Normal)
            startButton.enabled = true
            
            self.config = config
        }
    }
    
    @IBAction func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? TaskViewController, task = task, config = config {
            destination.taskRun = task.run(config)
        }
    }
    
}
