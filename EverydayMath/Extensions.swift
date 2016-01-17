//
//  Extensions.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 10.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

extension UIView {    
    class func loadFromNibNamed(nibNamed: String, index: Int = 0, bundle: NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[index] as? UIView
    }
}