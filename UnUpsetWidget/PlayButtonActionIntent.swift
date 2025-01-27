//
//  PlayButtonActionIntent.swift
//  UnUpset
//
//  Created by Андрей Степанов on 27.01.2025.
//

import SwiftUI
import AppIntents

struct PlayButtonActionIntent: AppIntent {
    static var title: LocalizedStringResource = "PlayButtonAction"
    
    func perform() async throws -> some IntentResult {
        print("widget button pressed")
        TimerManager.shared.startTimer()
        ShieldManager.shared.shieldActivities()
        return .result()
    }
}
