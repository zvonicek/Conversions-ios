//
//  ClosedEndedQuestionView.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 29.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit
import TZStackView
import OALayoutAnchor

class ClosedEndedQuestionView: UIView {
    @IBOutlet var questionLabel: UILabel!
    var answerButtons = [ClosedEndedButton]()

    var delegate: QuestionDelegate?
    
    var stackView = TZStackView() {
        didSet {
            stackView.axis = .Vertical
            stackView.alignment = .Center
            stackView.spacing = 25
        }
    }
    
    var question: ClosedEndedQuestion! {
        didSet {
            questionLabel.text = question.configuration.question
            
            var buttons = [UIView()]
            answerButtons = [ClosedEndedButton]()
            
            for answerCfg in question.configuration.answers {
                let button = ClosedEndedButton(answerCfg: answerCfg)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(self, action: "answerSelected:", forControlEvents: UIControlEvents.TouchUpInside)
                button.oa_widthAnchor.constraintEqualToConstant(CGRectGetWidth(self.frame) - 80).oa_active = true
                button.oa_heightAnchor.constraintEqualToConstant(50).oa_active = true
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
            self.addConstraint(NSLayoutConstraint(item: stackView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -120.0))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for button in answerButtons {
            button.oa_widthAnchor.constraintEqualToConstant(CGRectGetWidth(self.frame) - 80).oa_active = true
        }
    }
    
    func answerSelected(sender: ClosedEndedButton) {
        markButton(sender)
        
        var correct = true
        if !question.configuration.correctAnswers().contains(sender.answerCfg) {
            // selected answer is not correct
            correct = false
            
            let correctButtons = answerButtons.filter { $0.answerCfg.correct }
            if let correctButton = correctButtons.first {
                markButton(correctButton)
            }
        }
        
        delegate?.questionCompleted(question, correct: correct, answer: ["answer": sender.answerCfg.answer])
    }
    
    private func markButton(button: ClosedEndedButton) {
        if question.configuration.correctAnswers().contains(button.answerCfg) {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                button.backgroundColor = UIColor.correctColor()
                }) { (completed: Bool) -> Void in
            }
        } else {
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 25, 0)
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                button.backgroundColor = UIColor.errorColor()
                button.layoutIfNeeded()
                }) { (completed: Bool) -> Void in
            }
        }
    }
}
