//
//  AddtivieAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class AdditiveAction: ActionParameter {
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue2), perLevel: String(actionValue3), key: nil)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch actionValue1 {
        case 0:
            let format = NSLocalizedString("Add [%@ * HP] to next effect.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: .none, style: style, property: property, hasBracesIfNeeded: true))
        case 1:
            let format = NSLocalizedString("Add [%@ * lost HP] to next effect.", comment: "")
            return String(format: format, buildExpression(of: level, roundingRule: .none, style: style, property: property, hasBracesIfNeeded: true))
        case 2:
            let format = NSLocalizedString("Add [%@ * defeated enemy count] to next effect.", comment: "")
            return String(format: format, buildExpression(of: level, style: style, property: property, hasBracesIfNeeded: true))
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
    
}
