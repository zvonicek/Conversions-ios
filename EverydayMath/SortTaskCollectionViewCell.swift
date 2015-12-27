//
//  SortTaskCollectionViewCell.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 20.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class SortTaskCollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var hintLabel: UILabel!
    
    func configureForItem(item: SortTaskItem) {
        self.label.text = item.title
        self.hintLabel.text = item.errorExplanation
    }
}
