//
//  AboutViewController.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 05.03.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UINavigationBarDelegate {

    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "This application was developed by Petr Zvonicek at Faculty of Informatics, Masaryk University as a part of Adaptive Learning research group.\n\nIf you like this app, you may also like our other educational systems. The complete list is available on http://www.fi.muni.cz/adaptivelearning/?a=projects\n\nIn case of any questions or suggestions for further improvement, you can contact the author at zvonicek@gmail.com"
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    @IBAction func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
