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
    
    private init() {
        userDefaults = UserDefaults(suiteName: "group.UnUpsetDeveloper.UnUpset")!
    }
    
    var startDate: Date? {
        get { userDefaults.object(forKey: "TimerStartDate") as? Date }
        set { userDefaults.set(newValue, forKey: "TimerStartDate") }
    }
    
    var isActive: Bool {
        get { userDefaults.bool(forKey: "TimerIsActive") }
        set { userDefaults.set(newValue, forKey: "TimerIsActive") }
    }
    
    func removeStartDate() {
        userDefaults.removeObject(forKey: userDefaultsKeyStartDate)
    }
}
