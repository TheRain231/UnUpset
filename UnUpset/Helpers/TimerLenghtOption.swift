//
//  TimerLenghtOption.swift
//  UnUpset
//
//  Created by Андрей Степанов on 10.03.2025.
//

import SwiftUI

enum TimerLenghtOption: String, CaseIterable {
    case min5 = "5 min"
    case min15 = "15 min"
    case min25 = "25 min"
    case min35 = "35 min"
    case min45 = "45 min"
    case min55 = "55 min"
    
    func toSeconds() -> Double {
        switch self {
        case .min5:
            300
        case .min15:
            900
        case .min25:
            1500
        case .min35:
            2100
        case .min45:
            2700
        case .min55:
            3300
        }
    }
}
