//
//  GameHeaderView.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 20.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation

class GameHeaderView: UIView {
    @IBOutlet var timer: KKProgressTimer!
    @IBOutlet var progressView: ProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timer.progressColor = UIColor.redColor()
        timer.progressBackgroundColor = UIColor.greenColor()        
    }    
}