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
        label.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(label)
    }
    
    func configure(category: GameCategory) {
        self.label.text = category.description()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
