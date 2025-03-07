//
//  ContentViewModel.swift
//  UnUpset
//
//  Created by Андрей Степанов on 06.03.2025.
//

import Foundation

extension ContentView {
    final class ViewModel: ObservableObject {
        @Published var showPermissionsSheet = false
    }
    
    func requestNotifications() {
        NotificationManager.shared.requestNotificationAuthorization()
    }
    
    func requestFamilyControls() {
        Task {
            _ = await ShieldManager.shared.requestAuthorization()
        }
    }
}
