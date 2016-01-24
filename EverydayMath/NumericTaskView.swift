//
//  NumericTaskView.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit
import OALayoutAnchor

class NumericTaskView: UIView, NumpadViewDelegate {
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var toValueTextField: UITextField!
    @IBOutlet var toUnitLabel: UILabel!
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var middleView: UIView!
    var hintView: UIView?
    
    @IBOutlet var numpad: NumpadView!
    
    var task: NumericTask! {
        didSet {
            fromLabel.text = String(format: "%.0f", task.configuration.fromValue) + " " + task.configuration.fromUnit
            toUnitLabel.text = task.configuration.toUnit
            if let imageView = imageView, let image = task.configuration.image {
                imageView.image = image
            }
        }
    }
    var delegate: TaskDelegate?
    
    override func awakeFromNib() {
        numpad.delegate = self
        self.backgroundColor = UIColor.clearColor()
        
        if UIScreen.mainScreen().bounds.size.height == 480 {
            numpad.oa_heightAnchor.constraintEqualToConstant(180).oa_active = true
//            middleView.oa_heightAnchor.constraintEqualToConstant(80).oa_active = true
        }
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
            handleSuccess(number)
        } else {
            if let hint = task.configuration.hint where self.hintView == nil {
                handleFailure()
                
                let hintView = hint.getHintView()
                self.hintView = hintView
                showHintView(hintView)
                
                delegate?.taskGaveSecondTry(task)
            } else {
                handleSecondFailure(number)
                
                self.userInteractionEnabled = false
            }
        }
    }
    
    private func handleSuccess(number: Float) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.toValueTextField.backgroundColor = UIColor.correctColor()
        }, completion: { _ -> Void in
            self.delegate?.taskCompleted(self.task, correct: true, answer: ["number": String(number)])
        })
    }
    
    private func handleFailure() {
        let color = self.toValueTextField.backgroundColor
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.toValueTextField.backgroundColor = UIColor.errorColor()
            }, completion: { _ -> Void in
                UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.toValueTextField.backgroundColor = color
                    }, completion: { _ -> Void in
                        self.toValueTextField.text = ""
                })
        })
    }
    
    private func handleSecondFailure(number: Float) {
        let color = self.toValueTextField.backgroundColor
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.toValueTextField.backgroundColor = UIColor.errorColor()
            }, completion: { _ -> Void in
                UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.toValueTextField.backgroundColor = color
                    }, completion: { _ -> Void in
                        self.toValueTextField.text = String(format: "%.0f", self.task.configuration.toValue)
                        self.delegate?.taskCompleted(self.task, correct: false, answer: ["number": String(number)])
                })
        })
    }
    
    private func showHintView(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(view)
        view.frame = CGRectMake(0, -view.frame.size.height, self.frame.width, view.frame.size.height)
        UIView.animateWithDuration(0.4, delay: 1.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
            }, completion: nil)
    }
}
