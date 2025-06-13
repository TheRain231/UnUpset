//
//  TimerLenghtOption.swift
//  UnUpset
//
//  Created by Андрей Степанов on 10.03.2025.
//

import SwiftUI

enum TimerLenghtOption: String, CaseIterable {
    case min5 = "5min"
    case min15 = "15min"
    case min25 = "25min"
    case min35 = "35min"
    case min45 = "45min"
    case min55 = "55min"
    
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
