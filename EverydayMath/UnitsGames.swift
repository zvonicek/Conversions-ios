//
//  UnitConversionGame.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 01.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

class UnitConversionGame: Game {
    var identifier: String
    var name: String
    var image: UIImage
    var category: GameCategory
    var gameConfiguration: GameConfiguration?
    
    init(identifier: String, name: String, category: GameCategory, image: UIImage) {
        self.identifier = identifier
        self.name = name
        self.category = category
        self.image = image
    }
    
    func run(configuration: GameConfiguration) throws -> GameRun {
        return DefaultGameRun(game: self, config: configuration)
    }
}
