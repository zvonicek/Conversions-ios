//
//  UIAlertController+Error.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 05.03.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func alertControllerWithError(error: NSError, handler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alertController = UIAlertController(title: error.localizedDescription, message: error.localizedRecoverySuggestion ?? "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: handler))
        return alertController
    }
}