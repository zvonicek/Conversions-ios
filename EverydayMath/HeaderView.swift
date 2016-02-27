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
        
        self.backgroundColor = UIColor(red: 77/255.0, green: 170/255.0, blue: 171/255.0, alpha: 1.0)
        self.addSubview(label)
//        self.addTopBorderWithColor(UIColor.lightGrayColor(), width: 1.0)
//        self.addBottomBorderWithColor(UIColor.lightGrayColor(), width: 1.0)
    }
    
    func configure(category: GameCategory) {
        self.label.text = category.description().uppercaseString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
