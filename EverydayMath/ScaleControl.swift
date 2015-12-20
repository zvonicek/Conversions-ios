//
//  ScaleControl.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 06.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

@IBDesignable class ScaleControl: UIControl {

    var minValue: CGFloat = 10.5
    var maxValue: CGFloat = 35.4
    
    let contentInsets = UIEdgeInsetsMake(20, 20, 20, 20)
    
    func labelPositions(rect: CGRect, range: Int) -> (index: Int) -> Bool {
        let labelWidth = CGFloat(20)
        let minRange = CGFloat(range) * labelWidth / CGRectGetWidth(rect)
        
        var value: Int
        switch minRange {
        case 0...1:
            value = 1
        case 1...10:
            value = 10
        case 10...100:
            value = 100
        default:
            value = 0
        }
        
        return { $0 % value == 0 }
    }
    
    override func drawRect(rect: CGRect) {
        let startValue = Int(minValue * 10)
        let endValue = Int(maxValue * 10)
        let intervalSize = endValue - startValue
        let scaleRect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(rect.height * 0.2, 10, rect.height * 0.4, 10))
        let labelPositions = self.labelPositions(scaleRect, range: intervalSize)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        
        UIColor.blackColor().setStroke()
        UIColor.whiteColor().setFill()
        
        for i in startValue...endValue {
            let xPosition = CGRectGetMinX(scaleRect) + CGRectGetWidth(scaleRect) * CGFloat(Float(i - startValue) / Float(intervalSize))
            
            var lineHeight: CGFloat?
            var fontSize: Int = 0
            
            if i % 100 == 0 {
                // print '10' line
                lineHeight = CGRectGetHeight(scaleRect)
                fontSize = 16
            } else if i % 10 == 0 {
                // print '1' line
                lineHeight = CGRectGetHeight(scaleRect) * 0.4
                fontSize = 12
            } else {
                // print '0.1' line
                if (intervalSize < 100) {
                }
            }

            if let lineHeight = lineHeight {
                CGContextMoveToPoint(context, xPosition, CGRectGetMinY(scaleRect) + (CGRectGetHeight(scaleRect) - lineHeight) / 2)
                CGContextAddLineToPoint(context, xPosition, CGRectGetMinY(scaleRect) + (CGRectGetHeight(scaleRect) - lineHeight) / 2 + lineHeight)
                CGContextStrokePath(context)
            }
            
            if labelPositions(index: i) {
                drawLabel(scaleRect, xPosition: xPosition, i: i, fontSize: CGFloat(fontSize))
            }
            
        }
    }
    
    func drawLabel(scaleRect: CGRect, xPosition: CGFloat, i: Int, fontSize: CGFloat) {
        let label: NSString = "\(i)"
        
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let font = UIFont.systemFontOfSize(fontSize)
        let attributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        let labelSize = CGFloat(20)
        let topPadding = labelSize / 2 - font.lineHeight / 2
        label.drawInRect(CGRectMake(xPosition - labelSize / 2, CGRectGetMaxY(scaleRect) + labelSize / 2 + topPadding, labelSize, labelSize), withAttributes: attributes)
        
    }
}
