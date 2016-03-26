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
    @IBOutlet var topSpace: NSLayoutConstraint!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var buttonsContainer: UIView!
    @IBOutlet var imageContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imageSpace: NSLayoutConstraint!
    @IBOutlet var imageView: UIImageView!
    
    var answerButtons = [ClosedEndedButton]()

    var delegate: QuestionDelegate?
    
    var stackView = TZStackView() {
        didSet {
            stackView.axis = .Vertical
            stackView.distribution = .Fill
            stackView.alignment = .Center
            stackView.spacing = UIScreen.mainScreen().bounds.size.height == 480 ? 5 : 15
        }
    }
    
    var question: ClosedEndedQuestion! {
        didSet {
            questionLabel.text = question.configuration.question
            
            if let image = question.configuration.image {
                imageView.image = image
                imageContainerHeightConstraint.constant = 90
            } else {
                imageContainerHeightConstraint.constant = 0
            }
            
            var stackViews =  [UIView]()
            answerButtons = [ClosedEndedButton]()
            
            for answerCfg in question.configuration.answers {
                let button = ClosedEndedButton(answerCfg: answerCfg)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(self, action: #selector(ClosedEndedQuestionView.answerSelected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                stackViews.append(button)
                answerButtons.append(button)
            }
            
            stackView = TZStackView(arrangedSubviews: stackViews)            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            buttonsContainer.addSubview(stackView)
            let views: [String:AnyObject] = [
                "questionLabel": questionLabel,
                "stackView": stackView
            ]
            buttonsContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[stackView]|",
                options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            buttonsContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[stackView]|",
                options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for button in answerButtons {
            if self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular && self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Regular {
                button.oa_heightAnchor.constraintEqualToConstant(60).oa_active = true
                button.oa_widthAnchor.constraintEqualToConstant(450).oa_active = true
            } else {
                let height = UIScreen.mainScreen().bounds.size.height == 480 ? CGFloat(44) : CGFloat(50)
                button.oa_heightAnchor.constraintEqualToConstant(height).oa_active = true
                button.oa_widthAnchor.constraintEqualToConstant(CGRectGetWidth(self.frame) - 80).oa_active = true
            }
        }
    }
    
    override func awakeFromNib() {
        if UIScreen.mainScreen().bounds.size.height == 480 {
            topSpace.constant = 10
        }
        if UIScreen.mainScreen().bounds.size.width == 320 {
            imageSpace.constant = 5
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
        
        delegate?.questionCompleted(question, correct: correct, accuracy: .NonApplicable, answer: self.question.answerLogForAnswer(sender.answerCfg.answer))
    }
    
    private func markButton(button: ClosedEndedButton) {
        if question.configuration.correctAnswers().contains(button.answerCfg) {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                button.backgroundColor = UIColor.correctColor()
                }) { (completed: Bool) -> Void in
            }
        } else {
            if button.answerCfg.explanation != nil {
                button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 25, 0)
            }
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                button.backgroundColor = UIColor.errorColor()
                button.layoutIfNeeded()
                }) { (completed: Bool) -> Void in
            }
        }
    }
}
