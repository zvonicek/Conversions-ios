//
//  HintView.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 13.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import UIKit

class ScaleHintView: UIView {
    @IBOutlet var scaleControl: DoubleScaleControl!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!

    class func instanceFromNib() -> ScaleHintView {
        let view = UINib(nibName: "HintView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ScaleHintView
        return view
    }
}
