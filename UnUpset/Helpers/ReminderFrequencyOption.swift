//
//  ReminderFrequencyOption.swift
//  UnUpset
//
//  Created by Андрей Степанов on 10.03.2025.
//

import SwiftUI

enum ReminderFrequencyOption: String, CaseIterable {
    case min30 = "30min"
    case h1 = "1h"
    case h2 = "2h"
    case h3 = "3h"
    case h4 = "4h"
    
    func toHours() -> Double {
        switch self {
        case .min30:
            return 0.5
        case .h1:
            return 1
        case .h2:
            return 2
        case .h3:
            return 3
        case .h4:
            return 4
        }
    }
    
    func toMinutes() -> Double {
        switch self {
        case .min30:
            return 30
        case .h1:
            return 60
        case .h2:
            return 120
        case .h3:
            return 180
        case .h4:
            return 240
        }
    }
}
