//
//  ArrayRandomItem.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 16.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}