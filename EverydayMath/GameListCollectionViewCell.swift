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
    
    func configureForTask(game: Task) {
        self.label.text = game.name
        self.task = game
        self.imageView.image = game.image
    }
}
