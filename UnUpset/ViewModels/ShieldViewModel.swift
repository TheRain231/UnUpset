//
//  SettingsViewModel.swift
//  UnUpset
//
//  Created by Андрей Степанов on 21.11.2024.
//

import Foundation
import SwiftUI
import Combine
import MessageUI

extension SettingsView {
    final class ViewModel: ObservableObject {
        @ObservedObject var shieldManager = ShieldManager.shared
        @AppStorage("selectedAppearance") var selectedAppearance = AppearanceOption.auto.rawValue
        @AppStorage("timerLenght") var timerLenght = TimerLenghtOption.min5
        @AppStorage("reminderFrequency") var reminderFrequency = ReminderFrequencyOption.h3
        
        @Published var notifications = NotificationManager.shared.notificationsEnabled
        @Published var showAlertOnNotifications = false
        @Published var showActivityPicker = false
        @Published var showPickerUnavailableAlert = false

        
        @Published var showFeedbackForm = false
        @Published var showMailUnavailableAlert = false
        
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
            $showActivityPicker
                .sink { newValue in
                    if !newValue {
                        ShieldManager.shared.updateCategories()
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
        
        func selectTimerLenght(_ option: TimerLenghtOption) {
            timerLenght = option
            TimerManager.shared.limit = option.toSeconds()
        }
        
        func selectRemindersFrequency(_ option: ReminderFrequencyOption) {
            print("reminderFrequency changing to \(option.rawValue)")
            reminderFrequency = option
            NotificationManager.shared.scheduleNotifications(frequency: option.toMinutes())
        }
        
        func mailButtonAction() {
            if MFMailComposeViewController.canSendMail() {
                showFeedbackForm = true
            } else {
                showMailUnavailableAlert = true
            }
        }

        func selectAppsAction() {
            print(TimerManager.shared.isActive)
            if TimerManager.shared.isActive {
                showPickerUnavailableAlert = true
            } else {
                showActivityPicker = true
            }
        }
    }
}
