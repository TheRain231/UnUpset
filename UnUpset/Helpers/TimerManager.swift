//
//  TimerManager.swift
//  UnUpset
//
//  Created by Андрей Степанов on 26.01.2025.
//

import Foundation
import SwiftUI
import Combine

final class TimerManager: ObservableObject {
    static let shared = TimerManager()
        
    // MARK: Properties
    @Published var remainingTime: TimeInterval // 5 минут
    @Published var progress: Double = 0.0
    @Published var isActive: Bool = false
    
    let limit: TimeInterval = 5 * 60 // 5 минут
    
    private var timer: AnyCancellable?
    private let userDefaultsKeyStartDate = "TimerStartDate"
    private let userDefaultsKeyIsActive = "TimerIsActive"
    private let sharedDefaults = UserDefaults(suiteName: "group.UnUpsetDeveloper.UnUpset")
    
    // MARK: Functions
    init() {
        remainingTime = limit
    }
    
    func startTimer() {
        guard !isActive else { return } // Избегаем повторного запуска
        timer?.cancel() // Отмена предыдущего таймера
        saveState(isActive: true)
        NotificationManager.shared.performNotification()
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
        NotificationManager.shared.removePendingNotification()
        saveState(isActive: false)
        timer?.cancel()
        HapticEngine.shared.playXY()
        ShieldManager.shared.unshieldActivities()
        resetTimer()
    }
    
    private func updateTimer() {
        remainingTime -= remainingTime.truncatingRemainder(dividingBy: 1)

        if remainingTime > 0 {
            remainingTime -= 1
            progress = 1.0 - (remainingTime / limit)
        } else {
            stopTimer()
        }
    }
    
    func resetTimer() {
        remainingTime = limit
        progress = 0.0
        sharedDefaults?.removeObject(forKey: userDefaultsKeyStartDate)
        sharedDefaults?.set(false, forKey: userDefaultsKeyIsActive)
    }
    
    // MARK: Memory 
    func loadState() {
        if let startDate = sharedDefaults?.object(forKey: userDefaultsKeyStartDate) as? Date {
            let elapsedTime = Date().timeIntervalSince(startDate)
            remainingTime = max(limit - elapsedTime, 0)
            progress = 1.0 - (remainingTime / limit)
        }
        isActive = sharedDefaults?.bool(forKey: userDefaultsKeyIsActive) ?? false
        
        if isActive {
            resumeTimer()
        }
    }
    
    func saveState(isActive: Bool) {
        self.isActive = isActive
        sharedDefaults?.set(isActive, forKey: userDefaultsKeyIsActive)
        if isActive {
            let startDate = Date()
            sharedDefaults?.set(startDate, forKey: userDefaultsKeyStartDate)
        }
    }
}
