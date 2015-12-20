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
    var correctToleranceMin: Float
    var correctToleranceMax: Float
}

class ScaleTask: Task {
    var delegate: TaskDelegate?
    let configuration: ScaleTaskConfiguration
    
    init(config: ScaleTaskConfiguration) {
        configuration = config
    }
    
    func getView() -> UIView {
        let view = ScaleTaskView.loadFromNibNamed("ScaleTaskView") as! ScaleTaskView
//        view.delegate = self.delegate
//        view.task = self
        return view
    }
}