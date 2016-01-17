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
    let configuration: NumericTaskConfiguration
    let properties: TaskProperties = TaskProperties(fastTime: 5, neutralTime: 10)
    
    init(config: NumericTaskConfiguration) {
        configuration = config
    }
    
    func getView() -> UIView {
        let view = self.configuration.image == nil ? NumericTaskView.loadFromNibNamed("NumericTaskView") as! NumericTaskView : NumericTaskView.loadFromNibNamed("NumericTaskView", index: 1) as! NumericTaskView
        view.task = self
        view.delegate = self.delegate
        return view
    }
    
    func verifyResult(value: Float) -> Bool {
        if case configuration.minCorrectValue ... configuration.maxCorrectValue = value {
            return true
        } else {
            return false
        }
    }
    
    func identifier() -> String {
        return String(ObjectIdentifier(self).uintValue)
    }    
}

struct NumericTaskConfiguration: TaskConfiguration {
    let fromValue: Float
    let fromUnit: String
    let toValue: Float
    let toUnit: String
    let minCorrectValue: Float
    let maxCorrectValue: Float
    let image: UIImage?
    
    let hint: Hint?
}
