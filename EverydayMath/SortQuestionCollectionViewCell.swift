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
        self.label.text = item.title
        self.hintLabel.text = item.errorExplanation
    }
}
