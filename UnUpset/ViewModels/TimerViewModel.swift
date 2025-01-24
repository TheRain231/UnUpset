//
//  TimerViewModel.swift
//  UnUpset
//
//  Created by Андрей Степанов on 07.11.2024.
//

import Foundation
import SwiftUI
import Combine

final class TimerViewModel: ObservableObject {
    static let shared = TimerViewModel()

    // MARK: Properties
    @Published var remainingTime: TimeInterval = 5 * 60 // 5 минут
    @Published var progress: Double = 0.0
    @Published var isActive: Bool = false
    @Published var isFirstAppearance: Bool = true
    
    private var timer: AnyCancellable?
    private let limit: TimeInterval = 5 * 60
    private let userDefaultsKeyStartDate = "TimerStartDate"
    private let userDefaultsKeyIsActive = "TimerIsActive"
    
    func loadState() {
        if let startDate = UserDefaults.standard.object(forKey: userDefaultsKeyStartDate) as? Date {
            let elapsedTime = Date().timeIntervalSince(startDate)
            remainingTime = max(limit - elapsedTime, 0)
            progress = 1.0 - (remainingTime / limit)
        }
        isActive = UserDefaults.standard.bool(forKey: userDefaultsKeyIsActive)
        isFirstAppearance = true
        
        if isActive {
            resumeTimer() // Автоматически возобновляем таймер, если он активен
        }
    }
    
    func startTimer() {
        guard !isActive else { return } // Избегаем повторного запуска
        saveState(isActive: true)
        performNotification()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTimer()
            }
        remainingTime -= remainingTime.truncatingRemainder(dividingBy: 1)
    }
    
    func resumeTimer() {
        guard isActive else { return }
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTimer()
            }
    }
    
    func stopTimer() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["TIMER"])
        saveState(isActive: false)
        timer?.cancel()
        resetTimer()
    }
    
    private func updateTimer() {
        isFirstAppearance = false
        remainingTime -= remainingTime.truncatingRemainder(dividingBy: 1)

        if remainingTime > 0 {
            remainingTime -= 1
            progress = 1.0 - (remainingTime / limit)
        } else {
            stopTimer()
        }
    }
    
    private func saveState(isActive: Bool) {
        self.isActive = isActive
        UserDefaults.standard.set(isActive, forKey: userDefaultsKeyIsActive)
        if isActive {
            let startDate = Date()
            UserDefaults.standard.set(startDate, forKey: userDefaultsKeyStartDate)
        }
    }
    
    private func resetTimer() {
        remainingTime = limit
        progress = 0.0
        UserDefaults.standard.removeObject(forKey: userDefaultsKeyStartDate)
        UserDefaults.standard.set(false, forKey: userDefaultsKeyIsActive)
    }
    
    // MARK: UI helpers
    func stringMinutes() -> String {
        return String(format: "%01i", Int(self.remainingTime) / 60)
    }
    
    func stringSeconds() -> [charItem] {
        var arr: [charItem] = []
        let secondsInString = String(format: "%02i", Int(self.remainingTime) % 60, 0)
        
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
