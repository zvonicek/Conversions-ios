//
//  GameListCollectionViewCell.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 09.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import UIKit

class GameListCollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var imageView: UIImageView!
    var game: Game?
    
    func configureForGame(game: Game) {
        self.label.text = game.name
        self.game = game
        self.imageView.image = game.image
    }
}
