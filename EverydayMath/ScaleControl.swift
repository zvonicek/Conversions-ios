//
//  ScaleControl.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 06.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

enum LabelPosition {
    case Up, Bottom;
}

@IBDesignable class ScaleControl: UIControl {

    var minValue: CGFloat = 10.5
    var maxValue: CGFloat = 22.4
    
    var labelPosition: LabelPosition = .Bottom
    let contentInsets = UIEdgeInsetsMake(20, 20, 20, 20)
    
    private var contentRect: CGRect = CGRectZero
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    func initialize() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentRect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(self.bounds.height * 0.2, 10, self.bounds.height * 0.4, 10))
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
    
    private static func trailingZerosCount(var number: Int) -> Int {
        if (number == 0) {
            return 0
        }
        
        var counter = 0
        while number % 10 == 0 {
            counter++
            number /= 10
        }
        
        return counter
    }
    
    private func scalePoints(startValue: Int, endValue: Int) -> (index: Int) -> (lineHeight: CGFloat, fontSize: Int)? {
        var maxLevel: Int = 0
        for i in startValue...endValue {
            let level = Int(pow(Float(10), Float(ScaleControl.trailingZerosCount(i))))
            if level > maxLevel {
                maxLevel = level
            }
        }
        
        return {index in
            if index % maxLevel == 0 {
                return (lineHeight: CGRectGetHeight(self.contentRect), fontSize: 16)
            } else if index % (maxLevel / 10) == 0 {
                return (lineHeight: CGRectGetHeight(self.contentRect) * 0.4, fontSize: 12)
            } else {
                return nil
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        let startValue = Int(minValue * 10)
        let endValue = Int(maxValue * 10)
        let intervalSize = endValue - startValue
        
        let labelSize = NSString(format: "%d", Int(maxValue)).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16)])
        let labelPositions = self.labelPositions(contentRect, labelWidth: labelSize.width, range: intervalSize)
        let scalePoints = self.scalePoints(startValue, endValue: endValue)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        
        for i in startValue...endValue {
            UIColor.whiteColor().setStroke()
            UIColor.whiteColor().setFill()
            
            let xPosition = CGRectGetMinX(contentRect) + CGRectGetWidth(contentRect) * CGFloat(Float(i - startValue) / Float(intervalSize))
            
            if let point = scalePoints(index: i) {
                CGContextMoveToPoint(context, xPosition, CGRectGetMinY(contentRect) + (CGRectGetHeight(contentRect) - point.lineHeight) / 2)
                CGContextAddLineToPoint(context, xPosition, CGRectGetMinY(contentRect) + (CGRectGetHeight(contentRect) - point.lineHeight) / 2 + point.lineHeight)
                CGContextStrokePath(context)

                if labelPositions(index: i) {
                    let number = i / 10
                    drawLabel(contentRect, xPosition: xPosition, i: number, fontSize: CGFloat(point.fontSize))
                }
            }
        }
    }
    
    func drawLabel(scaleRect: CGRect, xPosition: CGFloat, i: Int, fontSize: CGFloat) {
        let label: NSString = "\(i)"
        
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let font = UIFont.systemFontOfSize(fontSize)
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        let labelSize = label.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16)])
        
        let topPadding = labelSize.height / 2 - font.lineHeight / 2
        label.drawInRect(CGRectMake(xPosition - labelSize.width / 2, CGRectGetMaxY(scaleRect) + labelSize.height / 2 + topPadding, labelSize.width, labelSize.height), withAttributes: attributes)
        
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
        resultView.backgroundColor = UIColor.greenColor()
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
