//
//  GameListCollectionViewCell.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 09.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class TaskListCollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var imageView: UIImageView!
    var task: Task?
    
    override func awakeFromNib() {
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = UIColor(red: 133/255.0, green: 219/255.0, blue: 130/255.0, alpha: 1.0).CGColor
    }
    
    func configureForTask(game: Task) {
        self.label.text = game.name
        self.task = game
        self.imageView.image = game.image
    }
}
