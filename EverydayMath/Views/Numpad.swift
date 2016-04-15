//
//  Numpad.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

enum NumpadButtonType {
    case Numeric(value: Int)
    case Delete
    case Enter
    
    var descrpition: String {
        switch self {
        case .Numeric(let val):
            return "\(val)"
        case .Delete:
            return "⌫"
        case .Enter:
            return "SUBMIT"
        }
    }
}

class NumpadButton: UIButton {
    
    var type: NumpadButtonType = .Enter
    
    convenience init(position: Int) {
        self.init()
        
        if position < 9 {
            type = .Numeric(value: position + 1)
        } else if position == 9 {
            type = .Delete
        } else if position == 10 {
            type = .Numeric(value: 0)
        } else {
            type = .Enter
        }
        
        self.setTitle("\(type.descrpition)", forState: UIControlState.Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
}

protocol NumpadViewDelegate {
    func numpadDidTapOnButton(button: NumpadButton)
}

@IBDesignable
class NumpadView: UIView {
    
    let numberButtons: [NumpadButton] = (0..<12).map {i in NumpadButton(position: i) }
    var delegate: NumpadViewDelegate?
    
    let rows = 4
    let cols = 3
    let sep = CGFloat(2)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.initialize()
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
        
        self.initialize()
    }
    
    func initialize() {
        self.contentMode = UIViewContentMode.Redraw
        
        for button in numberButtons {
            button.addTarget(self, action: #selector(NumpadView.didTapOnButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(button)
        }
    }
    
    func didTapOnButton(button: NumpadButton) {
        delegate?.numpadDidTapOnButton(button)
    }
    
    func buttonSize() -> CGSize {
        return CGSizeMake((CGRectGetWidth(self.bounds) - sep * (CGFloat(cols) - 1)) / CGFloat(cols), ((CGRectGetHeight(self.bounds) - sep * (CGFloat(rows) - 1)) / CGFloat(rows)))
    }
    
    override func layoutSubviews() {
        var left = CGFloat(0)
        var top = CGFloat(0)
        
        for i in 0..<self.numberButtons.count {
            let button = self.numberButtons[i]
            button.frame = CGRectMake(left, top, buttonSize().width, buttonSize().height)
            
            if i % cols == 2 {
                left = CGFloat(0)
                top += buttonSize().height + sep
            } else {
                left += buttonSize().width + sep
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var colorComponents:[CGFloat] = [1.0, 1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 0.4, 1.0, 1.0, 1.0, 0.0]
        var verticalLocations:[CGFloat] = [0.0, 0.5, 1.0]
        let verticalGradient = CGGradientCreateWithColorComponents(colorSpace, &colorComponents, &verticalLocations, 3)
        var horizontalLocations:[CGFloat] = [1.0, 0.5, 0.0]
        let horizontalGradient = CGGradientCreateWithColorComponents(colorSpace, &colorComponents, &horizontalLocations, 3)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 0.0);
        
        for i in 1..<self.cols {
            CGContextSaveGState(context);
            CGContextAddRect(context, CGRectMake(buttonSize().width * CGFloat(i) + sep * CGFloat(i-1), 0, 1, rect.size.height));
            CGContextClip(context);
            CGContextDrawLinearGradient (context, verticalGradient, CGPointMake(0, 0), CGPointMake(0, rect.size.height), CGGradientDrawingOptions(rawValue: 0))
            CGContextRestoreGState(context);
        }
        
        for i in 1..<self.rows {
            CGContextSaveGState(context);
            CGContextAddRect(context, CGRectMake(0, buttonSize().height * CGFloat(i) + sep * CGFloat(i-1), rect.size.width, 1));
            CGContextClip(context);
            CGContextDrawLinearGradient (context, horizontalGradient, CGPointMake(0, 0), CGPointMake(rect.size.width, 0), CGGradientDrawingOptions(rawValue: 0))
            CGContextRestoreGState(context);
        }
    }    
}