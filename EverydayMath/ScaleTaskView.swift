//
//  ScaleTaskView.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class ScaleTaskView: UIView, TrackingScaleControlDelegate {
    
    var delegate: TaskDelegate?
    var task: ScaleTask! {
        didSet {
            self.taskLabel.text = task.configuration.task
            
            self.scaleControl.minValue = CGFloat(task.configuration.scaleMin)
            self.scaleControl.maxValue = CGFloat(task.configuration.scaleMax)
            self.scaleControl.correctValue = CGFloat(task.configuration.correctValue)
            self.scaleControl.correctTolerance = CGFloat(task.configuration.correctTolerance)
        }
    }
    
    @IBOutlet var taskLabel: UILabel!
    @IBOutlet var scaleControl: TrackingScaleControl!
    @IBOutlet var resultView: UIView!
    @IBOutlet var resultTextLabel: UILabel!
    @IBOutlet var resultNumberLabel: UILabel!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clearColor()
        scaleControl.delegate = self
        resultView.alpha = 0.0
    }
    
    // MARK: TrackingScaleControlDelegate
    
    func scaleControlDidAnswer(value: CGFloat) {
        let isCorrect = Float(value) > task.configuration.correctValue - task.configuration.correctTolerance && Float(value) < task.configuration.correctValue + task.configuration.correctTolerance
        
        if  isCorrect {
            resultNumberLabel.backgroundColor = UIColor.correctColor()
        } else {
            resultNumberLabel.backgroundColor = UIColor.errorColor()
        }
        resultNumberLabel.text = String(format: "%.2f", task.configuration.correctValue)

        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.resultView.alpha = 1.0
        }) { (let finished) -> Void in
            self.delegate?.taskCompleted(self.task, correct: isCorrect)
        }
    }
}
