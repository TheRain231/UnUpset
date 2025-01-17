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
    
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = true {
        didSet {
            if notificationsEnabled {
                enableNotifications()
            } else {
                disableNotifications()
            }
        }
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                    if granted {
                        print("Notification access granted.")
                    } else {
                        print("Notification access denied.\(String(describing: error?.localizedDescription))")
                    }
                }
                return
            case .denied:
                print("Notification access denied")
                return
            case .authorized:
                print("Notification access granted.")
                return
            default:
                return
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
    
    func enableNotifications() {
        requestNotificationAuthorization()
        scheduleNotifications()
        print("Notifications have been enabled.")
    }
    
    func disableNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["DailyReminder10", "DailyReminder13", "DailyReminder16", "DailyReminder19"])
        notificationCenter.removeAllDeliveredNotifications()
        print("Notifications have been disabled.")
    }
}
