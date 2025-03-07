//
//  ShieldViewModel.swift
//  UnUpset
//
//  Created by Андрей Степанов on 21.11.2024.
//

import Foundation
import SwiftUI
import Combine

extension ShieldView {
    final class ViewModel: ObservableObject {
        @ObservedObject var shieldManager = ShieldManager.shared
        @AppStorage("selectedAppearance") var selectedAppearance = AppearanceOption.auto.rawValue
        
        @Published var notifications = NotificationManager.shared.notificationsEnabled
        @Published var showAlertOnNotifications = false
        
        private var cancellables = Set<AnyCancellable>()
        
        init() {
            $notifications
                .sink { [weak self] newValue in
                    guard let self = self else { return }
                    
                    if newValue {
                        NotificationManager.shared.enableNotifications()
                        
                        // Проверяем, включены ли уведомления в настройках, если нет — показываем алерт
                        UNUserNotificationCenter.current().getNotificationSettings { settings in
                            DispatchQueue.main.async {
                                if settings.authorizationStatus != .authorized {
                                    self.showAlertOnNotifications = true
                                    self.notifications = false // Сбрасываем toggle обратно
                                }
                            }
                        }
                    } else {
                        NotificationManager.shared.disableNotifications()
                    }
                }
                .store(in: &cancellables)
            NotificationCenter.default.publisher(for: .setUpNotification)
                .sink { [weak self] _ in
                    self?.notifications = true
                }
                .store(in: &cancellables)
        }
        
        func openSettings() {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }

        func selectAppearance(_ option: AppearanceOption) {
            selectedAppearance = option.rawValue
        }
    }
}
