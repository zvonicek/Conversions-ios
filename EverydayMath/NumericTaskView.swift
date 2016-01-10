//
//  NumericTaskView.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class NumericTaskView: UIView, NumpadViewDelegate {
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var toValueTextField: UITextField!
    @IBOutlet var toUnitLabel: UILabel!
    
    @IBOutlet var numpad: NumpadView!
    
    @IBOutlet var hintViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var hintViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var hintLabel: UILabel!
    
    var task: NumericTask! {
        didSet {
            fromLabel.text = String(format: "%.0f", task.taskConfiguration.fromValue) + " " + task.taskConfiguration.fromUnit
            toUnitLabel.text = task.taskConfiguration.toUnit
            hintLabel.text = task.taskConfiguration.hint
            hintLabel.hidden = true
        }
    }
    var delegate: TaskDelegate?
    
    override func awakeFromNib() {
        numpad.delegate = self
        self.backgroundColor = UIColor.clearColor()
        
        hintViewTopConstraint.constant = -hintViewHeightConstraint.constant
    }
    
    func numpadDidTapOnButton(button: NumpadButton) {
        switch button.type {
        case .Numeric(let value):
            toValueTextField.text = (toValueTextField.text ?? "") + "\(value)"
        case .Enter:
            let floatValue = (toValueTextField.text ?? "" as NSString).floatValue
            verifyResult(floatValue)
        case .Delete:
            if let text = toValueTextField.text {
                toValueTextField.text = String(text.characters.dropLast())
            }
        }
    }
    
    func verifyResult(number: Float) {
        let result = task.verifyResult(number)
        
        if result {
            handleSuccess()
        } else {
            handleFailure()
        }
    }
    
    private func handleSuccess() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.toValueTextField.backgroundColor = UIColor.greenColor()
        }, completion: { _ -> Void in
            self.delegate?.taskCompleted(self.task, correct: true)
        })
    }
    
    private func handleFailure() {
        let color = self.toValueTextField.backgroundColor
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.toValueTextField.backgroundColor = UIColor.redColor()
            }, completion: { _ -> Void in
                UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.toValueTextField.backgroundColor = color
                    }, completion: { _ -> Void in
                        self.toValueTextField.text = ""
                })
        })
        
        hintViewTopConstraint.constant = 0
        
        UIView.animateWithDuration(0.4, delay: 0.8, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.layoutIfNeeded()
            }, completion: nil)        
    }

}
