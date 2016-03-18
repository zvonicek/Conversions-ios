//
//  NumberFormatter.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 18.03.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

extension NSNumberFormatter {
    @nonobjc public static let formatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        return formatter
    }()
}