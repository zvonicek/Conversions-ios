//
//  IntHelpers.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 05.03.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

extension Int {
    /**
     Count trailing zeros in number
     
     - parameter number: number
     
     - returns: trailing zeros in number
     */
    func trailingZerosCount() -> Int {
        var number = self
        
        if (number == 0) {
            return 0
        }
        
        var counter = 0
        while number % 10 == 0 {
            counter += 1
            number /= 10
        }
        
        return counter
    }
    
}