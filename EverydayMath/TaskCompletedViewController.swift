//
//  TaskCompletedViewController.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 03.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class TaskCompletedViewController: UIViewController {

    @IBAction func dismiss() {
        self.presentingViewController?.presentingViewController?.modalTransitionStyle = UIModalTransitionStyle.CoverVertical;
        self.presentingViewController?.presentingViewController?.presentingViewController?.modalTransitionStyle = UIModalTransitionStyle.CoverVertical;
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
