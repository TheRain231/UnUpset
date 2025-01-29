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
    static var title: LocalizedStringResource = "Toggle 5-minute timer"
    static var description = IntentDescription("Starts or stops the 5-minute timer")
    
    func perform() async throws -> some IntentResult {
        TimerManager.shared.startTimer()
        ShieldManager.shared.shieldActivities()
        
        WidgetCenter.shared.reloadTimelines(ofKind: "UnUpsetWidget")

        return .result()
    }
}
