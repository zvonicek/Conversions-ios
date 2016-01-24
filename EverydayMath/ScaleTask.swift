//
//  ScaleTask.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 07.12.15.
//  Copyright © 2015 Petr Zvonicek. All rights reserved.
//

import Foundation

struct ScaleTaskConfiguration: TaskConfiguration {
    var task: String
    var scaleMin: Float
    var scaleMax: Float
    var correctValue: Float
    var correctTolerance: Float
    var toUnit: String
}

class ScaleTask: Task {
    var delegate: TaskDelegate?
    let configuration: ScaleTaskConfiguration
    let properties: TaskProperties = TaskProperties(taskId: "D", fastTime: 5, neutralTime: 10)
    
    init(config: ScaleTaskConfiguration) {
        configuration = config
    }
    
    func getView() -> UIView {
        let view = ScaleTaskView.loadFromNibNamed("ScaleTaskView") as! ScaleTaskView
        view.delegate = self.delegate
        view.task = self
        return view
    }
    
    func identifier() -> String {
        return String(ObjectIdentifier(self).uintValue)
    }
}