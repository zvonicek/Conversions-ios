//
//  GradientView.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 29.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {
    
    @IBInspectable var fromColor: UIColor = UIColor.whiteColor()
    @IBInspectable var toColor: UIColor = UIColor.blackColor()
    
    override func drawRect(rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext();
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let locations = [0.0, 1.0] as [CGFloat];
        let colors = [fromColor.CGColor, toColor.CGColor] as CFArrayRef
        
        let gradient = CGGradientCreateWithColors(colorspace, colors, locations);
        
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: 0, y: self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions.DrawsAfterEndLocation);
    }
}