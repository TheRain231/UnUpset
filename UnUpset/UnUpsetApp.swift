//
//  UnUpsetApp.swift
//  UnUpset
//
//  Created by Андрей Степанов on 07.11.2024.
//

import SwiftUI
import FamilyControls

@main
struct UnUpsetApp: App {
    @Environment(\.scenePhase) private var phase
    
    init(){
        TimerManager.shared.loadState()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .active:
                TimerManager.shared.loadState() // Обновляем состояние таймера
                NotificationCenter.default.post(name: .appOpened, object: nil)
            default:
                break
            }
        }
//        .backgroundTask(.appRefresh("removeLimit")) { _ in
//            await manager.unshieldActivities()
//        }
    }
}

extension Notification.Name {
    static let appOpened = Notification.Name("appOpened")
    static let requestNotificationsAuthorization = Notification.Name("requestNotificationsAuthorization")
    static let requestFamilyControlsAuthorization = Notification.Name("requestFamilyControlsAuthorization")
}
