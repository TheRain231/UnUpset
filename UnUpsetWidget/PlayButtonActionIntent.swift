//
//  PlayButtonActionIntent.swift
//  UnUpset
//
//  Created by Андрей Степанов on 27.01.2025.
//

import SwiftUI
import AppIntents
import WidgetKit

struct PlayButtonActionIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle the timer"
    static var description = IntentDescription("Starts or stops the timer")
    
    func perform() async throws -> some IntentResult {
        if !TimerData.shared.isActive && ShieldData.shared.hasFamilyAccess {
            TimerManager.shared.startTimer()
            ShieldManager.shared.shieldActivities()
        }
        
        WidgetCenter.shared.reloadTimelines(ofKind: "UnUpsetWidget")

        return .result()
    }
}
