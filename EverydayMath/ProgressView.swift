//
//  ProgressView.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 29.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

enum ProgressViewState {
    case Empty, Wrong, CorrectA, CorrectB, CorrectC
    
    func color() -> UIColor {
        switch self {
        case .Empty:
            return UIColor.clearColor()
        case .Wrong:
            return UIColor(white: 223/255.0, alpha: 1.0)
        case .CorrectA:
            return UIColor(red: 61/255.0, green: 195/255.0, blue: 50/255.0, alpha: 1.0)
        case .CorrectB:
            return UIColor(red: 242/255.0, green: 146/255.0, blue: 0/255.0, alpha: 1.0)
        case .CorrectC:
            return UIColor(red: 213/255.0, green: 53/255.0, blue: 82/255.0, alpha: 1.0)
        }
    }
}

class ProgressView: UIView {
    
    var usesRoundedCorners = true
    var barBorderWidth: CGFloat = 2.0
    var barBorderColor = UIColor(red: 224/255.0, green: 236/255.0, blue: 242/255.0, alpha: 1.0)
    var barInnerBorderWidth: CGFloat = 0.0
    var barInnerBorderColor: UIColor? = nil
    var barInnerPadding: CGFloat = 0.0
    var barBackgroundColor = UIColor.whiteColor()
    var progress: CGFloat = 0.5
    var componentSeparatorBorderWidth: CGFloat = 1.0
    
    var components: Int = 10 {
        didSet {
            states = [ProgressViewState](count: components, repeatedValue: .Empty)
        }
    }
    var states: [ProgressViewState] = [.Wrong, .CorrectA, .CorrectB, .CorrectC, .Empty, .Empty, .Empty, .Empty, .Empty, .Empty]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    func initialize() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    func updateStateForComponent(index: Int, state: ProgressViewState) {
        states[index] = state
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSaveGState(context)
        CGContextSetAllowsAntialiasing(context, true)
        var currentRect: CGRect = rect
        var radius: CGFloat = 0
        var halfLineWidth: CGFloat = 0
        // Background
        if self.usesRoundedCorners {
            radius = currentRect.size.height / 2.0
        }
        self.barBackgroundColor.setFill()

        // Border
        halfLineWidth = self.barBorderWidth / 2.0
        currentRect = CGRectInset(currentRect, halfLineWidth, halfLineWidth)
        if self.usesRoundedCorners {
            radius = currentRect.size.height / 2.0
        }
        self.barBorderColor.setStroke()
        strokeRectInContext(context, currentRect, self.barBorderWidth, radius, radius)
        currentRect = CGRectInset(currentRect, halfLineWidth, halfLineWidth)
        
        // Padding
        currentRect = CGRectInset(currentRect, self.barInnerPadding, self.barInnerPadding)
        var hasInnerBorder: Bool = false
        
        // Inner border
        if let barInnerBorderColor = self.barInnerBorderColor {
            hasInnerBorder = true
            halfLineWidth = self.barInnerBorderWidth / 2.0
            currentRect = CGRectInset(currentRect, halfLineWidth, halfLineWidth)
            if self.usesRoundedCorners {
                radius = currentRect.size.height / 2.0
            }
            
            // progress
            currentRect.size.width *= self.progress
            currentRect.size.width = CGFloat(fmaxf(Float(currentRect.size.width), Float(CGFloat(2) * radius)))
            barInnerBorderColor.setStroke()
            strokeRectInContext(context, currentRect, self.barInnerBorderWidth, radius, radius)
            currentRect = CGRectInset(currentRect, halfLineWidth, halfLineWidth)
        }
        
        let componentWidth = currentRect.size.width * CGFloat(1/CGFloat(components))
        
        for i in 0..<components {
            let state = states[i]
            
            let leftPadding = i == 0 ? 0 : componentSeparatorBorderWidth
            let xPos = currentRect.size.width * CGFloat(Float(i)/Float(components)) + currentRect.origin.x + leftPadding
            state.color().setFill()
            
            let radiusLeft = i == 0 ? radius : 0.0
            let radiusRight = i == components - 1 ? radius : 0.0
            fillRectInContext(context, CGRectMake(xPos, currentRect.origin.y, componentWidth, currentRect.size.height), radiusLeft, radiusRight)
        }
        
        // Draw component's border
        for i in 1..<components {
            let xPos = currentRect.size.width * CGFloat(Float(i)/Float(components)) + currentRect.origin.x
            barBorderColor.setFill()
            fillRectInContext(context, CGRectMake(xPos, currentRect.origin.y, componentSeparatorBorderWidth, currentRect.size.height), 0.0, 0.0)
        }
        
        // Restore the context
        CGContextRestoreGState(context)
    }
}