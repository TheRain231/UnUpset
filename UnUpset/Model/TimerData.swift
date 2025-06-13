//
//  TimerData.swift
//  UnUpset
//
//  Created by Андрей Степанов on 29.01.2025.
//


import SwiftUI

class TimerData {
    static let shared = TimerData()
    
    private let userDefaults: UserDefaults
    private let userDefaultsKeyStartDate = "TimerStartDate"
    private let userDefaultsKeyIsActive = "TimerIsActive"
    private let userDefaultsRemainingTimeKey = "remainingTime"
    private let timerLenghtKey = "timerLenght"
    
    private init() {
        userDefaults = UserDefaults(suiteName: "group.UnUpsetDeveloper.UnUpset")!
    }
    
    var timerLenght: Double {
        get { userDefaults.double(forKey: timerLenghtKey) }
        set { userDefaults.set(newValue, forKey: timerLenghtKey) }
    }
    
    var remainingTime: Double {
        get { userDefaults.double(forKey: userDefaultsRemainingTimeKey) }
        set { userDefaults.set(newValue, forKey: userDefaultsRemainingTimeKey) }
    }
    
    var startDate: Date? {
        get { userDefaults.object(forKey: userDefaultsKeyStartDate) as? Date }
        set { userDefaults.set(newValue, forKey: userDefaultsKeyStartDate) }
    }
    
    var isActive: Bool {
        get { userDefaults.bool(forKey: userDefaultsKeyIsActive) }
        set { userDefaults.set(newValue, forKey: userDefaultsKeyIsActive) }
    }
    
    func removeStartDate() {
        userDefaults.removeObject(forKey: userDefaultsKeyStartDate)
    }
}
