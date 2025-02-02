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
    private var userDefaultsRemainingTimeKey = "remainingTime"
    
    private init() {
        userDefaults = UserDefaults(suiteName: "group.UnUpsetDeveloper.UnUpset")!
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
