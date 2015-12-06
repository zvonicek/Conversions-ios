//
//  GameCompletedViewController.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 03.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class GameCompletedViewController: UIViewController {

    @IBAction func dismiss() {
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
