//
//  ClosedEndedButton.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 29.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class ClosedEndedButton: UIButton {

    let answerCfg: ClosedEndedTaskAnswerConfiguration
    let hintLabel = UILabel()
    
    init(answerCfg: ClosedEndedTaskAnswerConfiguration) {
        self.answerCfg = answerCfg
        
        super.init(frame: CGRectZero)
        
        hintLabel.text = "= " + (answerCfg.explanation ?? "")
        hintLabel.textAlignment = NSTextAlignment.Center
        hintLabel.textColor = UIColor.whiteColor()
        self.addSubview(hintLabel)
        
        self.setTitle(answerCfg.answer, forState: UIControlState.Normal)
        self.backgroundColor = UIColor.grayColor()
        self.clipsToBounds = true
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(250, 50)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        hintLabel.frame = CGRectMake(0, self.frame.size.height - self.titleEdgeInsets.bottom, self.frame.size.width, 20)
    }
}
