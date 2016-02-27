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
    case Mass, Length, Area, Volume, Currency
    
    func description() -> String {
        switch self {
        case .Mass:
            return "Mass"
        case .Length:
            return "Length"
        case .Area:
            return "Area"
        case .Volume:
            return "Volume"
        case .Currency:
            return "Currency"
        }
    }
}

protocol Game {
    var identifier: String { get }
    var name: String { get }
    var image: UIImage { get }
    var category: GameCategory { get }
    var gameConfiguration: GameConfiguration? { get }
    
    func run(configuration: GameConfiguration) throws -> GameRun
}


class GameFactory {
    static let games: [Game] = [
        UnitConversionGame(identifier: "mass_i", name: "Imperial", category: .Mass, image: UIImage(named: "ic_mass")!),
        UnitConversionGame(identifier: "mass_m", name: "Metric", category: .Mass, image: UIImage(named: "ic_mass")!),
        UnitConversionGame(identifier: "mass_mi", name: "Combined", category: .Mass, image: UIImage(named: "ic_mass")!),
        
        UnitConversionGame(identifier: "length_i", name: "Imperial", category: .Length, image: UIImage(named: "ic_length")!),
        UnitConversionGame(identifier: "length_m", name: "Metric", category: .Length, image: UIImage(named: "ic_length")!),
        UnitConversionGame(identifier: "length_mi", name: "Combined", category: .Length, image: UIImage(named: "ic_length")!),
        
        UnitConversionGame(identifier: "area_i", name: "Imperial", category: .Area, image: UIImage(named: "ic_area")!),
        UnitConversionGame(identifier: "area_m", name: "Metric", category: .Area, image: UIImage(named: "ic_area")!),
        UnitConversionGame(identifier: "area_mi", name: "Combined", category: .Area, image: UIImage(named: "ic_area")!),
    ]
    static var gamesByCategory: [GameCategory: [Game]] = {
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
    static var categories: [GameCategory] = {
        return GameFactory.games.reduce([], combine: { (var arr: [GameCategory], var game: Game) -> [GameCategory] in
            if !arr.contains(game.category) {
                arr.append(game.category)
            }
            
            return arr
        })
    }()
    
    init() {
    }
}