//
//  HintConfiguration.swift
//  EverydayMath
//
//  Created by Petr Zvoníček on 02.03.16.
//  Copyright © 2016 Petr Zvonicek. All rights reserved.
//

import Foundation
import Unbox

protocol HintConfiguration: Unboxable {
    init(unboxer: Unboxer)
    func getHintView() -> UIView
}

enum HintType: String {
    case Scale = "hintScale"
    case Text = "hintText"
    
    static func unbox(dict: UnboxableDictionary) -> HintConfiguration? {
        guard let typeString = dict["type"] as? String, let type = HintType(rawValue: typeString)
            else { return nil }
        
        switch type {
        case .Scale:
            let q: ScaleHintConfiguration? = Unbox(dict)
            return q
        case .Text:
            let q: TextHintConfiguration? = Unbox(dict)
            return q
        }
    }
}

extension Unboxer {
    func unbox(key: String) -> HintConfiguration? {
        guard let dict = self.dictionary[key] as? UnboxableDictionary
            else { return nil }
        
        return HintType.unbox(dict)
    }
}

// MARK: hints

struct ScaleHintConfiguration: HintConfiguration {
    var topUnit: String
    var topMin: Float
    var topMax: Float
    
    var bottomUnit: String
    var bottomMin: Float
    var bottomMax: Float
    
    init(unboxer: Unboxer) {
        topUnit = unboxer.unbox("topUnit")
        topMin = unboxer.unbox("topMin")
        topMax = unboxer.unbox("topMax")
        bottomUnit = unboxer.unbox("bottomUnit")
        bottomMin = unboxer.unbox("bottomMin")
        bottomMax = unboxer.unbox("bottomMax")
    }
    
    func getHintView() -> UIView {
        let view = ScaleHintView.instanceFromNib()
        view.configure(topMin: topMin, topMax: topMax, topUnit: topUnit, bottomMin: bottomMin, bottomMax: bottomMax, bottomUnit: bottomUnit)                
        return view
    }
}

struct TextHintConfiguration: HintConfiguration {
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
    init(unboxer: Unboxer) {
        text = unboxer.unbox("text")
    }
    
    func getHintView() -> UIView {
        let view = NumericHintView.instanceFromNib()
        view.label.text = text
        return view
    }
}