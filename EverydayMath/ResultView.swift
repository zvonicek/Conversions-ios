//
//  ResultView.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 16.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

class ResultView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var subtitleWrapper: UIView!
    @IBOutlet var resultTitleLabel: UILabel?
    @IBOutlet var resultValueLabel: UILabel?
    var finalResult = true
    
    class func instanceFromNib(showResult: Bool) -> ResultView {
        if showResult {
            return UINib(nibName: "ResultView", bundle: nil).instantiateWithOwner(nil, options: nil)[1] as! ResultView
        } else {
            return UINib(nibName: "ResultView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ResultView
        }
    }
    
    func setSuccessWithMessage(message: String, result: SimpleResult?) {
        self.backgroundColor = UIColor(red: 189/255.0, green: 242/255.0, blue: 149/255.0, alpha: 1.0)
        self.titleLabel.textColor = UIColor(red: 61/255.0, green: 188/255.0, blue: 14/155.0, alpha: 1.0)
        self.subtitleLabel.textColor = UIColor(red: 107/255.0, green: 167/255.0, blue: 27/255.0, alpha: 1.0)
        self.subtitleWrapper.backgroundColor = UIColor(red: 167/255.0, green: 236/255.0, blue: 118/255.0, alpha: 1.0)
        
        self.titleLabel.text = message
        self.subtitleLabel.text = NSLocalizedString("Tap to continue", comment: "Tap anywhere to continue")
        
        if let result = result, resultTitleLabel = resultTitleLabel, resultValueLabel = resultValueLabel {
            resultTitleLabel.textColor = self.titleLabel.textColor
            resultValueLabel.textColor = self.titleLabel.textColor
            resultValueLabel.text = result.value
            
            if let title = result.title {
                resultTitleLabel.text = title
            }
        }
    }
    
    func setFailureWithMessage(message: String, subtitle: String?, result: SimpleResult?) {
        self.backgroundColor = UIColor(red: 252/255.0, green: 186/255.0, blue: 186/255.0, alpha: 1.0)
        self.titleLabel.textColor = UIColor(red: 193/255.0, green: 30/255.0, blue: 23/155.0, alpha: 1.0)
        self.subtitleLabel.textColor = UIColor(red: 209/255.0, green: 70/255.0, blue: 67/255.0, alpha: 1.0)
        self.subtitleWrapper.backgroundColor = UIColor(red: 240/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1.0)

        self.titleLabel.text = message
        self.subtitleLabel.text = subtitle ?? NSLocalizedString("Tap to continue", comment: "Tap anywhere to continue")
        
        if let result = result, resultTitleLabel = resultTitleLabel, resultValueLabel = resultValueLabel {
            resultTitleLabel.textColor = self.titleLabel.textColor
            resultValueLabel.textColor = self.titleLabel.textColor
            resultValueLabel.text = result.value
            
            if let title = result.title {
                resultTitleLabel.text = title
            }
        }
    }
}