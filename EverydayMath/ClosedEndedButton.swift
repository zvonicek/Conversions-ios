//
//  ClosedEndedButton.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 29.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class ClosedEndedButton: UIButton {

    let answerCfg: ClosedEndedQuestionAnswerConfiguration
    let hintLabel = UILabel()
    
    init(answerCfg: ClosedEndedQuestionAnswerConfiguration) {
        self.answerCfg = answerCfg
        
        super.init(frame: CGRectZero)
        
        if let explanation = answerCfg.explanation {
            hintLabel.text = "= " + explanation
        } else {
            hintLabel.text = ""
        }
        
        hintLabel.textAlignment = NSTextAlignment.Center
        hintLabel.textColor = UIColor.whiteColor()
        self.addSubview(hintLabel)
        
        self.setTitle(answerCfg.answer, forState: UIControlState.Normal)
        self.backgroundColor = UIColor(red: 255/255.0, green: 189/255.0, blue: 153/255.0, alpha: 1.0)
        self.setTitleColor(UIColor(red: 93/255.0, green: 36/255.0, blue: 36/255.0, alpha: 1.0), forState: UIControlState.Normal)
        self.titleLabel?.font = UIFont.boldSystemFontOfSize(16.0)
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        hintLabel.frame = CGRectMake(0, self.frame.size.height - self.titleEdgeInsets.bottom, self.frame.size.width, 20)
    }
}
