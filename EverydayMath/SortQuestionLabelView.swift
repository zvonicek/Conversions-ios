//
//  SortTaskLabel.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 23.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import UIKit

class SortQuestionLabelView: UICollectionReusableView {
    let label = UILabel()
    
    override init(frame: CGRect) {
        label.frame = CGRectMake(15, 0, frame.size.width - 30, frame.size.height)
        label.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        label.textColor = UIColor.whiteColor()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(label)
    }    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

