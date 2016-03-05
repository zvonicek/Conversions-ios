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
    
    func configure(topMin topMin: Float, topMax:Float, topUnit: String, bottomMin: Float, bottomMax: Float, bottomUnit: String) {
        self.topLabel.text = topUnit
        self.scaleControl.topScaleControl.minValue = CGFloat(topMin)
        self.scaleControl.topScaleControl.maxValue = CGFloat(topMax)
        self.bottomLabel.text = bottomUnit
        self.scaleControl.bottomScaleControl.minValue = CGFloat(bottomMin)
        self.scaleControl.bottomScaleControl.maxValue = CGFloat(bottomMax)
        
        // simple heuristics to prevent trailing label overflow on long values
        let trailingLabel = String(format: "%g", max(topMax, bottomMax))
        let rightPadding = CGFloat(max(0, (trailingLabel.characters.count - 2) * 4))
        
        self.scaleControl.topScaleControl.rightBorderPadding = rightPadding
        self.scaleControl.bottomScaleControl.rightBorderPadding = rightPadding
    }
}
