//
//  DoubleScaleControl.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 30.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

@IBDesignable class DoubleScaleControl: UIView {
    
    let topScaleControl: ScaleControl = {
        let ctr = ScaleControl()
        ctr.labelPosition = .Top
        ctr.drawOuterSideToEdge = true
        ctr.labelPadding = 0.0
        return ctr
    }()
    let bottomScaleControl: ScaleControl = {
        let ctr = ScaleControl()
        ctr.drawOuterSideToEdge = true        
        ctr.labelPadding = 0.0
        return ctr
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    func initialize() {
        self.addSubview(topScaleControl)
        self.addSubview(bottomScaleControl)
        
        topScaleControl.minValue = 0
        topScaleControl.maxValue = 3
        bottomScaleControl.minValue = 0
        bottomScaleControl.maxValue = 1.36
    }
    
    override func layoutSubviews() {
        topScaleControl.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height / 2)
        bottomScaleControl.frame = CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2)
    }
}
