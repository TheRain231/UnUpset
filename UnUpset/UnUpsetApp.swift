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
        NotificationManager.shared.requestNotificationAuthorization()
        NotificationManager.shared.scheduleNotifications()        
    }
    
    let center = AuthorizationCenter.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Task{
                        do {
                            try await center.requestAuthorization(for: .individual)
                        } catch {
                            print("Failed to enroll individual user with error: \(error.localizedDescription)")
                        }
                    }
                }
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .active:
                NotificationCenter.default.post(name: .loadState, object: nil) // Обновляем состояние таймера
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
    static let loadState = Notification.Name("loadState")
}
