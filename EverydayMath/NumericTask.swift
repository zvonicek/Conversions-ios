//
//  NumericTaskConfiguration.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 30.11.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation

class NumericTask: Task {
    var delegate: TaskDelegate?
    let taskConfiguration: NumericTaskConfiguration
    
    init(config: NumericTaskConfiguration) {
        taskConfiguration = config
    }
    
    func getView() -> UIView {
        let view = NumericTaskView.loadFromNibNamed("NumericTaskView") as! NumericTaskView
        view.task = self
        view.delegate = self.delegate
        return view
    }
    
    func verifyResult(value: Float) -> Bool {
        if case taskConfiguration.minCorrectValue ... taskConfiguration.maxCorrectValue = value {
            return true
        } else {
            return false
        }
    }
}

struct NumericTaskConfiguration: TaskConfiguration {
    let fromValue: Float
    let fromUnit: String
    let toValue: Float
    let toUnit: String
    let minCorrectValue: Float
    let maxCorrectValue: Float
    
    let hint: String
}
