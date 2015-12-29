//
//  GameConfiguration.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation

// Task-specific configuration
protocol TaskConfiguration {
    
}

// MARK: GameConfiguration

protocol GameConfiguration {
    var tasks: [TaskConfiguration] { get }
}

struct TimeBasedGameConfiguration: GameConfiguration {
    let tasks: [TaskConfiguration]
    let time: NSTimeInterval
}