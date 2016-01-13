//
//  HintConfiguration.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 13.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

protocol Hint {
    func getHintView() -> UIView
}

struct ScaleHint: Hint {
    var topUnit: String
    var topMin: Float
    var topMax: Float
    
    var bottomUnit: String
    var bottomMin: Float
    var bottomMax: Float
    
    func getHintView() -> UIView {
        let view = ScaleHintView.instanceFromNib()
        view.topLabel.text = topUnit
        view.scaleControl.topScaleControl.minValue = CGFloat(topMin)
        view.scaleControl.topScaleControl.maxValue = CGFloat(topMax)
        view.bottomLabel.text = bottomUnit
        view.scaleControl.bottomScaleControl.minValue = CGFloat(bottomMin)
        view.scaleControl.bottomScaleControl.maxValue = CGFloat(bottomMax)
        
        return view
    }
}

struct NumericHint: Hint {
    var text: String
    
    func getHintView() -> UIView {
        let view = NumericHintView.instanceFromNib()
        view.label.text = text
        return view
    }
}