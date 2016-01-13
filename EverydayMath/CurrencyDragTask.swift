//
//  CurrencyDragTask.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 10.01.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation

struct CurrencyDragTaskConfigurationNote {
    let value: Float
    let currency: String
}

struct CurrencyDragTaskConfiguration: TaskConfiguration {
    let fromValue: Float
    let fromCurrency: String
    let toValue: Float
    let toCurrency: String
    let tolerance: Float
    let fromNotes: [CurrencyDragTaskConfigurationNote]
    let availableNotes: [(note: CurrencyDragTaskConfigurationNote, count: Int)]
    let hint: Hint?
}

class CurrencyDragTask: Task {
    var delegate: TaskDelegate?    
    let configuration: CurrencyDragTaskConfiguration
    let properties = TaskProperties(fastTime: 5, neutralTime: 10)
    
    init(config: CurrencyDragTaskConfiguration) {
        configuration = config
    }
    
    func getView() -> UIView {
        let view = SortTaskView.loadFromNibNamed("CurrencyDragTaskView") as! CurrencyDragTaskView
        view.task = self
        view.delegate = self.delegate
        return view
    }
    
    func verifyResult(notesSum: Float) -> Bool {
        return (abs(notesSum - self.configuration.toValue) < self.configuration.tolerance)
    }
    
    func identifier() -> String {
        return String(ObjectIdentifier(self).uintValue)
    }
}