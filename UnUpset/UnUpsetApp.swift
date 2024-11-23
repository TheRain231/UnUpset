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
    //@AppStorage("hasSelection") var doesntHasSelection: Bool = true
    
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
                //.familyActivityPicker(isPresented: $doesntHasSelection, selection: $manager.discouragedSelections)
        }
    }
}
