//
//  NotificationManager.swift
//  UnUpset
//
//  Created by Андрей Степанов on 08.11.2024.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager {
    static let shared = NotificationManager()
    
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = false {
        didSet {
            if notificationsEnabled {
                NotificationManager.shared.scheduleNotifications()
            }
        }
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                        DispatchQueue.main.async {
                            if granted {
                                print(".notDetermined: Notification access granted.")
                                self.enableNotifications()
                                NotificationCenter.default.post(name: .setUpNotification, object: nil)
                            } else {
                                print(".notDetermined: Notification access denied: \(String(describing: error?.localizedDescription))")
                                self.notificationsEnabled = false
                            }
                        }
                    }
                    
                case .denied:
                    print(".denied: Notification access denied")
                    self.notificationsEnabled = false
                    
                case .authorized:
                    print(".authorized: Notification access granted.")
                    self.notificationsEnabled = true
                    
                default:
                    break
                }
            }
        }
    }
    
    func createCalendarNotification(title: String, body: String, dateComponents: DateComponents, identifier: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier]) // Remove previous pending notification with same identifier
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func scheduleNotifications(){
        let hours = [10, 13, 16, 19]
        
        for hour in hours {
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            
            let identifier = "DailyReminder\(hour)"
            
            createCalendarNotification(title: "It's time to work!", body: "You better set this timer!", dateComponents: dateComponents, identifier: identifier)
        }
    }
    
    func performNotification() {
        let content = UNMutableNotificationContent()
        content.title = "You did it!"
        content.body = "Open the app to unlock your phone"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(TimerManager.shared.limit), repeats: false)
        
        let request = UNNotificationRequest(identifier: "TIMER", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func removePendingNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["TIMER"])
    }
    
    func enableNotifications() {
        notificationsEnabled = true
        requestNotificationAuthorization()
        scheduleNotifications()
        print("Notifications have been enabled.")
    }
    
    func disableNotifications() {
        notificationsEnabled = false

        Task {
            let dailyReminderIdentifiers = await getPendingNotifications().filter { $0.starts(with: "DailyReminder") }
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removePendingNotificationRequests(withIdentifiers: dailyReminderIdentifiers)
            notificationCenter.removeAllDeliveredNotifications()
            
            print("Notifications have been disabled.")
        }
    }
    
    private func getPendingNotifications() async -> [String] {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                let identifiers = requests.map { $0.identifier }
                continuation.resume(returning: identifiers)
            }
        }
    }
    
    private func printPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print("Идентификатор: \(request.identifier)")
                print("Контент заголовка: \(request.content.title)")
                print("Контент тела: \(request.content.body)")
                print("Триггер: \(String(describing: request.trigger))")
                print("------")
            }
        }
    }
}

extension Notification.Name {
    static let setUpNotification = Notification.Name("setUpNotification")
}
