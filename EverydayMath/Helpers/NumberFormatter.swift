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
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        return formatter
    }()
    
    @nonobjc public static let integerFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
}