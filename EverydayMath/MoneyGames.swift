//
//  MoneyGames.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 01.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

class CurrencyGame: Game {
    var identifier: String
    var name: String
    var image: UIImage
    var category: GameCategory
    var gameConfiguration: GameConfiguration?
    
    init(identifier: String, name: String, image: UIImage) {
        self.identifier = identifier
        self.name = name
        self.category = .Money
        self.image = image
    }
    
    func run(configuration: GameConfiguration) throws -> GameRun {
        return DefaultGameRun(game: self, config: configuration)
    }
}
