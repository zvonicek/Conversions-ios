//
//  HeaderView.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 09.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    let label = UILabel()
    
    override init(frame: CGRect) {
        label.frame = CGRectMake(15, 0, frame.size.width - 30, frame.size.height)
        label.font = UIFont.boldSystemFontOfSize(17)
        label.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 102/255.0, green: 194/255.0, blue: 73/255.0, alpha: 1.0)
        self.addSubview(label)
        self.addTopBorderWithColor(UIColor.whiteColor(), width: 1.0)
        self.addBottomBorderWithColor(UIColor.whiteColor(), width: 1.0)
    }
    
    func configure(category: TaskCategory) {
        self.label.text = category.description().uppercaseString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
