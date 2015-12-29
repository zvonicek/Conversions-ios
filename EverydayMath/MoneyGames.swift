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
    var category: GameCategory
    var gameConfiguration: GameConfiguration?
    
    init(identifier: String, name: String) {
        self.identifier = identifier
        self.name = name
        self.category = .Money
    }
    
    func run(configuration: GameConfiguration) throws -> GameRun {
        if let configuration =  configuration as? TimeBasedGameConfiguration {
            return DefaultGameRun(game: self, config: configuration)
        } else {
            throw GameError.InvalidConfiguration
        }
    }
}
