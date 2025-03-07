//
//  TimerManager.swift
//  UnUpset
//
//  Created by Андрей Степанов on 26.01.2025.
//

import Foundation
import SwiftUI
import Combine
import WidgetKit

final class TimerManager: ObservableObject {
    static let shared = TimerManager()
        
    // MARK: Properties
    @Published var remainingTime: TimeInterval
    @Published var progress: Double = 0.0
    @Published var isActive: Bool = false
    
    let limit: TimeInterval = 5 * 60 // 5 минут
    
    private var timer: AnyCancellable?
    
    // MARK: Functions
    init() {
        remainingTime = limit
    }
    
    func startTimer() {
        Task {
            guard await ShieldManager.shared.requestAuthorization() else {
                return
            }
            if !TimerData.shared.isActive {
                timer?.cancel() // Отмена предыдущего таймера
                saveState(isActive: true)
                NotificationManager.shared.performNotification()
                timer = Timer.publish(every: 1, on: .main, in: .common)
                    .autoconnect()
                    .sink { [weak self] _ in
                        self?.updateTimer()
                    }
            }
        }
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
        TimerData.shared.removeStartDate()
        TimerData.shared.isActive = false
        
        WidgetCenter.shared.reloadTimelines(ofKind: "UnUpsetWidget")
    }
    
    // MARK: Memory 
    func loadState() {
        if let startDate = TimerData.shared.startDate {
            let elapsedTime = Date().timeIntervalSince(startDate)
            remainingTime = max(limit - elapsedTime, 0)
            progress = 1.0 - (remainingTime / limit)
        }
        isActive = TimerData.shared.isActive
        
        if isActive {
            resumeTimer()
        }
    }
    
    func saveState(isActive: Bool) {
        DispatchQueue.main.async {
            self.isActive = isActive
            TimerData.shared.isActive = isActive
            if isActive {
                TimerData.shared.startDate = Date()
            }
        }
    }
}
