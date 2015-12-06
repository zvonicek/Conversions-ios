//
//  Game.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation

enum GameError: ErrorType {
    case InvalidConfiguration
}

enum GameCategory {
    case Units, Money
    
    func description() -> String {
        switch self {
        case .Units:
            return "Unit conversion"
        case .Money:
            return "Money"
        }
    }
}

protocol Game {
    var identifier: String { get }
    var name: String { get }
    var category: GameCategory { get }
    var gameConfiguration: GameConfiguration? { get }
    
    func run(configuration: GameConfiguration) throws -> GameRun
}


class GameFactory {
    static let games: [Game] = [UnitConversionGame(identifier: "mass", name: "Mass"),
        UnitConversionGame(identifier: "length", name: "Length"), UnitConversionGame(identifier: "area", name: "Area"), CurrencyGame(identifier: "currency", name: "Currency"), CurrencyGame(identifier: "discounting", name: "Discounting")]
    static var categories: [GameCategory: [Game]] = {
        return  GameFactory.games.reduce([:]) { (var dict, var game: Game) -> Dictionary<GameCategory, Array<Game>> in
            if var it = dict[game.category] {
                it.append(game)
                dict[game.category] = it
            } else {
                dict[game.category] = [game]
            }
            
            return dict
        }
    }()
    
    init() {
    }
}