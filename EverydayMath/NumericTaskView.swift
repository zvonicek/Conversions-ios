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
    var hintView: UIView?
    
    @IBOutlet var numpad: NumpadView!
    
    var task: NumericTask! {
        didSet {
            fromLabel.text = String(format: "%.0f", task.configuration.fromValue) + " " + task.configuration.fromUnit
            toUnitLabel.text = task.configuration.toUnit
        }
    }
    var delegate: TaskDelegate?
    
    override func awakeFromNib() {
        numpad.delegate = self
        self.backgroundColor = UIColor.clearColor()
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
        
        if let hint = task.configuration.hint where self.hintView == nil {
            let hintView = hint.getHintView()
            self.hintView = hintView
            showHintView(hintView)
        } else {
            delegate?.taskCompleted(task, correct: false)
        }
    }
    
    func showHintView(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(view)
        view.frame = CGRectMake(0, -view.frame.size.height, self.frame.width, view.frame.size.height)
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
            }, completion: nil)
    }
}
