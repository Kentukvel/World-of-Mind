//
//  Repeat.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/12/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import Foundation

enum Repeat: Int {
    case never = 0
    case everyDay
    case everyWeek
    case everyMonth
    case everyYear
    
    static func getRepeat(fromString string: String) -> Repeat {
        switch string {
        case "Never":
            return .never
        case "Every day":
            return .everyDay
        case "Every week" :
            return .everyWeek
        case "Every month":
            return .everyMonth
        case "Every year":
            return .everyYear
        default:
            return .never
        }
    }
    
    static func getString(fromRepeat: Repeat) -> String {
        
        switch fromRepeat {
        case .never:
            return "Never"
        case .everyDay:
            return "Every day"
        case .everyWeek:
            return "Every week"
        case .everyMonth:
            return "Every month"
        case .everyYear:
            return "Every year"
        }
    }

}
