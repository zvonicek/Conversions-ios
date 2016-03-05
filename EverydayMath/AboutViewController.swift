//
//  AboutViewController.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 05.03.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UINavigationBarDelegate {

    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    @IBAction func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
