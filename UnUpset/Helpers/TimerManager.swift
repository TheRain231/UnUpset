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
    
    private let defaults: UserDefaults
    private let suiteName = "group.UnUpsetDeveloper.UnUpset"
    
    // MARK: Properties
    @Published var remainingTime: TimeInterval = 5 * 60
    @Published var progress: Double = 0.0
    
    @Published var isActive: Bool = false
    
    var pendingLimit: TimeInterval {
        get { defaults.double(forKey: "pendingLimit") }
        set {
            defaults.set(newValue, forKey: "pendingLimit")
            WidgetCenter.shared.reloadTimelines(ofKind: "UnUpsetWidget")
        }
    }
    
    var limit: TimeInterval {
        get { defaults.double(forKey: "timerLimit") }
        set {
            defaults.set(newValue, forKey: "timerLimit")
            if !isActive {
                remainingTime = newValue
                pendingLimit = newValue
                progress = 0.0
                WidgetCenter.shared.reloadTimelines(ofKind: "UnUpsetWidget")
            }
        }
    }
    
    private var timer: AnyCancellable?
    
    // MARK: Initialization
    init() {
        defaults = UserDefaults(suiteName: suiteName)!
        setupDefaults()
        
        remainingTime = limit
        if pendingLimit == 0 {
            pendingLimit = limit
        }
    }
    
    private func setupDefaults() {
        let defaultValues: [String: Any] = [
            "timerLimit": 5 * 60,
            "pendingLimit": 5 * 60
        ]
        
        defaults.register(defaults: defaultValues)
    }
    
    // MARK: Timer Control
    func startTimer() {
        Task { @MainActor in // Гарантируем выполнение в главном потоке
            guard await ShieldManager.shared.requestAuthorization() else { return }
            
            if !TimerData.shared.isActive {
                timer?.cancel()
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
        let newRemainingTime = max(remainingTime - 1, 0)
        let newProgress = 1.0 - (newRemainingTime / pendingLimit)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.remainingTime = newRemainingTime
            self.progress = newProgress
            
            if newRemainingTime <= 0 {
                self.stopTimer()
            }
        }
    }
    
    func resetTimer() {
        pendingLimit = limit
        remainingTime = limit
        progress = 0.0
        TimerData.shared.removeStartDate()
        TimerData.shared.isActive = false
        
        WidgetCenter.shared.reloadTimelines(ofKind: "UnUpsetWidget")
    }
    
    // MARK: State Management
    func loadState() {
        if let startDate = TimerData.shared.startDate {
            let elapsedTime = Date().timeIntervalSince(startDate)
            remainingTime = max(pendingLimit - elapsedTime, 0)
            progress = 1.0 - (remainingTime / pendingLimit)
        }
        isActive = TimerData.shared.isActive
        
        if isActive {
            resumeTimer()
        }
    }
    
    func saveState(isActive: Bool) {
        DispatchQueue.main.async {
            self.isActive = isActive
            self.objectWillChange.send()
            self.defaults.set(isActive, forKey: "TimerIsActive")
            if isActive {
                let startDate = Date()
                self.defaults.set(startDate, forKey: "TimerStartDate")
            } else {
                self.defaults.removeObject(forKey: "TimerStartDate")
            }
            WidgetCenter.shared.reloadTimelines(ofKind: "UnUpsetWidget")
        }
    }
}


final class ShieldTaskTimerManager: ObservableObject {
    static let shared = ShieldTaskTimerManager()

    @Published var taskTimers: [UUID: TaskTimer] = [:]

    private var cancellables: [UUID: AnyCancellable] = [:]

    func startTimer(for taskID: UUID, duration: TimeInterval, onTick: @escaping (_ remaining: TimeInterval, _ progress: Double) -> Void, onComplete: @escaping () -> Void) {
        stopTimer(for: taskID) // Останавливаем старый, если есть

        var taskTimer = TaskTimer(taskID: taskID, duration: duration)
        taskTimers[taskID] = taskTimer

        cancellables[taskID] = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }

                taskTimer.remainingTime = max(taskTimer.remainingTime - 1, 0)
                taskTimer.progress = 1.0 - (taskTimer.remainingTime / taskTimer.duration)

                onTick(taskTimer.remainingTime, taskTimer.progress)

                if taskTimer.remainingTime <= 0 {
                    self.stopTimer(for: taskID)
                    onComplete()
                }
            }
    }

    func stopTimer(for taskID: UUID) {
        cancellables[taskID]?.cancel()
        cancellables.removeValue(forKey: taskID)
        taskTimers.removeValue(forKey: taskID)
    }

    struct TaskTimer {
        let taskID: UUID
        let duration: TimeInterval
        var remainingTime: TimeInterval
        var progress: Double = 0.0

        init(taskID: UUID, duration: TimeInterval) {
            self.taskID = taskID
            self.duration = duration
            self.remainingTime = duration
        }
    }
}
