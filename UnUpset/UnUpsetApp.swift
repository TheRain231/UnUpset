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
    @StateObject private var manager = ShieldManager()
    @Environment(\.scenePhase) private var phase
    
    init(){
        NotificationManager.shared.requestNotificationAuthorization()
        NotificationManager.shared.scheduleNotifications()        
    }
    
    let center = AuthorizationCenter.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(manager: manager)
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
            case .background:
                scheduleAppRefresh()
                
                TimerViewModel.shared.leftTime = Date()
            case .active:
                if TimerViewModel.shared.isActive {
                    let diff = Int(Date().timeIntervalSince(TimerViewModel.shared.leftTime))
                    
                    TimerViewModel.shared.addTime(diff)
                }
            default: break
            }
        }
        .backgroundTask(.appRefresh("removeLimit")) { _ in
            await manager.unshieldActivities()
        }
    }
}
