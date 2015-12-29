//
//  ClosedEndedTaskView.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 29.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit
import TZStackView

class ClosedEndedTaskView: UIView {
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerButtons = [ClosedEndedButton]()

    var delegate: TaskDelegate?
    
    var stackView = TZStackView() {
        didSet {
            stackView.axis = .Vertical
            stackView.alignment = .Center
            stackView.spacing = 25
        }
    }
    
    var task: ClosedEndedTask! {
        didSet {
            questionLabel.text = task.configuration.question
            
            var buttons = [UIView()]
            answerButtons = [ClosedEndedButton]()
            
            for answerCfg in task.configuration.answers {
                let button = ClosedEndedButton(answerCfg: answerCfg)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(self, action: "answerSelected:", forControlEvents: UIControlEvents.TouchUpInside)
                buttons.append(button)
                answerButtons.append(button)
            }
            
            stackView = TZStackView(arrangedSubviews: buttons)            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(stackView)
            let views: [String:AnyObject] = [
                "questionLabel": questionLabel,
                "stackView": stackView
            ]
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[stackView]|",
                options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            self.addConstraint(NSLayoutConstraint(item: stackView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: questionLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5.0))
            self.addConstraint(NSLayoutConstraint(item: stackView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -50.0))
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    func answerSelected(sender: ClosedEndedButton) {
        markButton(sender)
        
        var correct = true
        if !task.configuration.correctAnswers().contains(sender.answerCfg) {
            // selected answer is not correct
            correct = false
            
            let correctButtons = answerButtons.filter { $0.answerCfg.correct }
            if let correctButton = correctButtons.first {
                markButton(correctButton)
            }
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.8 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.taskCompleted(correct)
        }
    }
    
    private func markButton(button: ClosedEndedButton) {
        if task.configuration.correctAnswers().contains(button.answerCfg) {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                button.backgroundColor = UIColor.greenColor()
                }) { (completed: Bool) -> Void in
            }
        } else {
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 25, 0)
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                button.backgroundColor = UIColor.redColor()
                button.layoutIfNeeded()
                }) { (completed: Bool) -> Void in
            }
        }
    }
    
    func taskCompleted(correct: Bool) {
        delegate?.taskCompleted(task, correct: correct)
    }
}
