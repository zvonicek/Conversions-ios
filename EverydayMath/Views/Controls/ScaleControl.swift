//
//  ScaleControl.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 06.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

enum LabelPosition {
    case Top, Bottom;
}

@IBDesignable class ScaleControl: UIControl {

    var minValue: CGFloat = 10.5
    var maxValue: CGFloat = 22.4
    var font1 = UIFont.systemFontOfSize(16)
    var font2 = UIFont.systemFontOfSize(12)
    
    var labelPosition: LabelPosition = .Bottom
    var labelPadding: CGFloat = 10.0
    var drawOuterSideToEdge = false
    
    /// border paddings to prevent trailing label overflow
    var leftBorderPadding: CGFloat = 0.0
    var rightBorderPadding: CGFloat = 0.0
    
    private var contentRect: CGRect = CGRectZero
    private var labelSize: CGSize = CGSizeZero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    func initialize() {
        self.backgroundColor = UIColor.clearColor()
        self.contentMode = UIViewContentMode.Redraw
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Simple heuristics to determine the correct label size and fixing the problem with decimal number longer than the ending value
        if (maxValue - minValue < 10) {
            labelSize = NSString(string: "8.8").sizeWithAttributes([NSFontAttributeName: font1])
        } else {
            labelSize = NSString(format: "%g", maxValue).sizeWithAttributes([NSFontAttributeName: font1])
        }
        
        if labelPosition == .Bottom {
            contentRect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0, 10 + leftBorderPadding, labelSize.height + labelPadding, 10 + rightBorderPadding))
        } else {
            contentRect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(labelSize.height + labelPadding, 10 + leftBorderPadding, 0, 10 + rightBorderPadding))
        }
    }
    
    func valueForPoint(point: CGPoint) -> CGFloat {
        let positionInRange = (point.x - contentRect.origin.x) / contentRect.size.width
        return positionInRange * (maxValue - minValue) + minValue
    }
    
    func pointForValue(value: CGFloat) -> CGPoint {
        if value < minValue || value > maxValue {
            return CGPointZero
        }
        
        let positionInRange = (value - minValue) / (maxValue - minValue)
        return CGPointMake(positionInRange * contentRect.size.width + contentRect.origin.x, CGRectGetMidY(contentRect))
    }
    
    // MARK: drawing methods
        
    private func labelPositions(rect: CGRect, labelWidth: CGFloat, range: Int) -> (index: Int) -> Bool {
        let minRange = CGFloat(range) * labelWidth / CGRectGetWidth(rect)
        
        var value: Int = Int(pow(10, ceil(log10(minRange)) as CGFloat) as CGFloat)
        if (value / 5 > Int(minRange)) {
            value = value / 2
        } else if (value / 5 > Int(minRange)) {
            value = value / 5
        }
        
        return { $0 % value == 0 }
    }
        
    /**
     Returns curried function checking whether to draw a line on that index
     
     - parameter startValue: start value
     - parameter endValue:   end value
     
     - returns: curried function
     */
    private func scalePoints(startValue: Int, endValue: Int) -> (index: Int) -> (lineHeight: CGFloat, font: UIFont)? {
        // maxLevel is number 10^n describing the scale point level with smallest granularity
        var maxLevel: Int = 0
        for i in startValue...endValue {
            let level = Int(pow(Float(10), Float(i.trailingZerosCount())))
            if level > maxLevel {
                maxLevel = level
            }
        }
        
        return { index in
            if index % maxLevel == 0 {
                return (lineHeight: CGRectGetHeight(self.contentRect), font: self.font1)
            } else if index % (maxLevel / 2) == 0 {
                return (lineHeight: CGRectGetHeight(self.contentRect) * 0.6, font: self.font2)
            } else if index % (maxLevel / 10) == 0 {
                return (lineHeight: CGRectGetHeight(self.contentRect) * 0.4, font: self.font2)
            } else {
                return nil
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        let factor = maxValue-minValue < 1000 ? Float(100.0) : Float(1.0)
        
        let startValue = Int(minValue * CGFloat(factor))
        let endValue = Int(maxValue * CGFloat(factor))
        let intervalSize = endValue - startValue
        
        let labelPositions = self.labelPositions(contentRect, labelWidth: labelSize.width, range: intervalSize)
        let scalePoints = self.scalePoints(startValue, endValue: endValue)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        
        for i in startValue...endValue {
            UIColor.whiteColor().setStroke()
            UIColor.whiteColor().setFill()
            
            let xPosition = CGRectGetMinX(contentRect) + CGRectGetWidth(contentRect) * CGFloat(Float(i - startValue) / Float(intervalSize))
            
            if let point = scalePoints(index: i) {
                let topYposition = drawOuterSideToEdge && labelPosition == .Bottom ? CGRectGetMinY(contentRect)
                    : CGRectGetMinY(contentRect) + (CGRectGetHeight(contentRect) - point.lineHeight) / 2
                let bottomYposition = drawOuterSideToEdge && labelPosition == .Top ? CGRectGetMaxY(contentRect)
                    : CGRectGetMinY(contentRect) + (CGRectGetHeight(contentRect) - point.lineHeight) / 2 + point.lineHeight
                
                CGContextMoveToPoint(context, xPosition, topYposition)
                CGContextAddLineToPoint(context, xPosition, bottomYposition)
                CGContextStrokePath(context)

                if labelPositions(index: i) {
                    let number = String(format: "%g", Float(i) / factor)
                    drawLabel(contentRect, xPosition: xPosition, label: number, font: point.font)
                }
            }
        }
    }
    
    func drawLabel(scaleRect: CGRect, xPosition: CGFloat, label: String, font: UIFont) {
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        let labelSize = label.sizeWithAttributes([NSFontAttributeName: font1])
        
        let topPadding = labelSize.height / 2 - font.lineHeight / 2
        
        if labelPosition == .Bottom {
            label.drawInRect(CGRectMake(xPosition - labelSize.width / 2, CGRectGetMaxY(self.bounds) - labelSize.height + topPadding, labelSize.width, labelSize.height), withAttributes: attributes)
        } else {
            label.drawInRect(CGRectMake(xPosition - labelSize.width / 2, topPadding, labelSize.width, labelSize.height), withAttributes: attributes)
        }
    }
}

protocol TrackingScaleControlDelegate: class {
    func scaleControlDidAnswer(value: CGFloat)
}

class TrackingScaleControl: ScaleControl {
    
    var correctTolerance: CGFloat = 1.0
    var correctValue: CGFloat = 15.5
    
    weak var delegate: TrackingScaleControlDelegate?
    
    private let positionView: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, 20, 20))
        view.backgroundColor = UIColor.whiteColor()
        view.alpha = 0.5
        view.hidden = true
        view.userInteractionEnabled = false
        return view
    }()
    
    
    override func initialize() {
        super.initialize()
        
        self.addSubview(positionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // set appropriate position view frame
        let positionViewWidth = CGRectGetWidth(contentRect) * CGFloat(correctTolerance * 2 / (maxValue - minValue))
        positionView.frame = CGRectMake(positionView.frame.origin.x, contentRect.origin.y, positionViewWidth, contentRect.size.height)
    }

    // MARK: tracking handling
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        positionView.hidden = false
        setViewForTouch(touch)
        return true
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        setViewForTouch(touch)
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        self.userInteractionEnabled = false
        
        let resultView = UIView(frame: CGRectMake(-10, CGRectGetMidY(contentRect) - 10, 10, 10))
        resultView.backgroundColor = UIColor(red: 255/255.0, green: 227/255.0, blue: 67/255.0, alpha: 1.0)
        resultView.alpha = 0.5
        self.addSubview(resultView)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            resultView.center = self.pointForValue(self.correctValue)
            }) { (finished) -> Void in
            self.delegate?.scaleControlDidAnswer(self.valueForPoint(self.positionView.center))
        }
    }
    
    private func setViewForTouch(touch: UITouch) {
        let point = touch.locationInView(self)
        let xPosition = max(contentRect.origin.x, min(CGRectGetMaxX(contentRect), point.x))
        positionView.center = CGPointMake(xPosition, positionView.center.y)
    }
}
