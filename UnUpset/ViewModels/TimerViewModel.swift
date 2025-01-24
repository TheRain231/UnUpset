//
//  TimerViewModel.swift
//  UnUpset
//
//  Created by Андрей Степанов on 07.11.2024.
//

import Foundation
import SwiftUI

final class TimerViewModel: ObservableObject {
    static let shared = TimerViewModel()

    // MARK: Properties
    @Published private(set) var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published private(set) var isActive: Bool = false
    @Published private(set) var progress: CGFloat = 0.0
    @Published private var count = 0 {
        didSet {
            self.secondsLeft = self.limit - self.count
            self.progress = CGFloat(self.count) / CGFloat(limit)
        }
    }
    @Published private(set) var secondsLeft: Int = 0
    let limit: Int = 5 * 60

    private let userDefaults = UserDefaults.standard
    private let backgroundTimeKey = "backgroundTimeKey"
    private let inactiveTimeKey = "inactiveTimeKey"
    private let savedCountKey = "countKey"
    private let isActiveKey = "isActiveKey"

    // MARK: Init
    init() {
        loadState()
    }

    // MARK: Functions
    func cycle() {
        if self.isActive {
            if self.count < limit {
                self.count += 1
            } else {
                self.pause()
            }
        }
    }

    func pause() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["TIMER"])
        self.isActive = false
        self.count = 0
        self.secondsLeft = self.limit
        saveState()
    }

    func startButtonAction() {
        if !self.isActive {
            if self.count >= limit {
                self.count = 0
                self.progress = 0
            }
            self.isActive = true
            saveState()
        }
    }

    func restartButtonAction() {
        self.count = 0
        self.progress = 0
        saveState()
    }

    func addTime(_ time: Int) {
        if time >= 0 {
            withAnimation {
                self.count += time
            }
        } else {
            self.pause()
        }
        saveState()
    }

    // Сохранение времени ухода в background
    func saveBackgroundTime() {
        userDefaults.set(Date(), forKey: backgroundTimeKey)
    }

    // Сохранение времени ухода в inactive
    func saveInactiveTime() {
        userDefaults.set(Date(), forKey: inactiveTimeKey)
    }

    // Обновление времени при возврате из background или inactive
    func updateFromInactiveOrBackground() {
        let now = Date()

        if let inactiveTime = userDefaults.object(forKey: inactiveTimeKey) as? Date {
            let elapsedTime = Int(now.timeIntervalSince(inactiveTime))
            addTime(elapsedTime)
            userDefaults.removeObject(forKey: inactiveTimeKey) // Очистка, чтобы не учитывать повторно
        }

        if let backgroundTime = userDefaults.object(forKey: backgroundTimeKey) as? Date {
            let elapsedTime = Int(now.timeIntervalSince(backgroundTime))
            addTime(elapsedTime)
            userDefaults.removeObject(forKey: backgroundTimeKey) // Очистка, чтобы не учитывать повторно
        }
    }

    private func saveState() {
        userDefaults.set(count, forKey: savedCountKey)
        userDefaults.set(isActive, forKey: isActiveKey)
    }

    private func loadState() {
        self.count = userDefaults.integer(forKey: savedCountKey)
        self.isActive = userDefaults.bool(forKey: isActiveKey)
        self.secondsLeft = max(self.limit - self.count, 0)
    }
    
    // MARK: UI helpers
    func stringMinutes() -> String {
        String(format: "%01i", self.secondsLeft / 60)
    }
    
    func stringSeconds() -> [charItem] {
        var arr: [charItem] = []
        let secondsInString = String(format: "%02i", max(self.secondsLeft % 60, 0))
        
        for symb in secondsInString {
            arr.append(charItem(symb))
        }
        
        return arr
    }
    
    private func performNotification() {
        let content = UNMutableNotificationContent()
        content.title = "You did it!"
        content.body = "Open the app to unlock your phone"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(self.limit), repeats: false)
        
        let request = UNNotificationRequest(identifier: "TIMER", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
        }
    }
}

struct charItem: Identifiable{
    let symbol: String
    let id = UUID()
    
    init(_ symbol: Character) {
        self.symbol = String(symbol)
    }
}
