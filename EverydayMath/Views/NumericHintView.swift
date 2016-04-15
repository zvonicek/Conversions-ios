//
//  NumericHintView.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 13.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import UIKit

class NumericHintView: UIView {
    @IBOutlet var label: UILabel!

    class func instanceFromNib() -> NumericHintView {
        let view = UINib(nibName: "HintView", bundle: nil).instantiateWithOwner(nil, options: nil)[1] as! NumericHintView
        return view
    }
}
