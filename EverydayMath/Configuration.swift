//
//  GameConfiguration.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation

// MARK: Task-specific configuration
protocol TaskConfiguration {
    
}

// MARK: GameConfiguration

struct GameConfiguration {
    var tasks: [TaskConfiguration]
}