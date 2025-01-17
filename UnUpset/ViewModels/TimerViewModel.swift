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
    @Published var leftTime: Date = Date()
    
    private let userDefaults = UserDefaults.standard
    private let savedTimeKey = "leftTime"
    private let savedCountKey = "count"
    private let isActiveKey = "isActive"
    
    // MARK: Init
    init() {
        loadState()
        self.secondsLeft = max(self.limit - self.count, 0)
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
            performNotification()
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
    
    private func saveState() {
        userDefaults.set(Date(), forKey: savedTimeKey)
        userDefaults.set(count, forKey: savedCountKey)
        userDefaults.set(isActive, forKey: isActiveKey)
    }
    
    private func loadState() {
        if let savedDate = userDefaults.object(forKey: savedTimeKey) as? Date {
            leftTime = savedDate
            let elapsedTime = Int(Date().timeIntervalSince(savedDate))
            
            if let savedCount = userDefaults.value(forKey: savedCountKey) as? Int {
                count = savedCount + (isActive ? elapsedTime : 0)
            }
        }
        isActive = userDefaults.bool(forKey: isActiveKey)
        self.secondsLeft = max(self.limit - self.count, 0) // Обновляем оставшееся время
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
