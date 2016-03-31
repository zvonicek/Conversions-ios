//
//  SortQuestionCollectionViewCell.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 20.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class SortQuestionCollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var hintLabel: UILabel!
    
    @IBOutlet var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet var hintLabelTopConstraint: NSLayoutConstraint!
    
    var item: SortQuestionItem?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.label.textColor = UIColor(red: 83/255.0, green: 117/255.0, blue: 127/255.0, alpha: 1.0)
    }
    
    func configureForItem(item: SortQuestionItem) {
        self.item = item
        
        self.label.text = item.title
        if let explanation = item.errorExplanation {
            self.hintLabel.text = "= \(explanation)"
        }
    }
    
    func showExplanation() {
        if let item = self.item where item.errorExplanation != nil {
            self.labelTopConstraint.constant = 8
            self.hintLabelTopConstraint.constant = 28
            
            UIView.animateWithDuration(0.3) {
                self.layoutIfNeeded()
            }
        }
    }
}
