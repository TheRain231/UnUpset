//
//  ShieldData.swift
//  UnUpset
//
//  Created by Андрей Степанов on 29.01.2025.
//


import SwiftUI
import ManagedSettings


class ShieldData {
    static let shared = ShieldData()
    private let userDefaults: UserDefaults
    
    private let savedApplicationsKey = "savedApplications"
    private let savedCategoriesKey = "savedCategories"
    private let hasFamilyAccessKey = "hasFamilyAccess"
    
    private init() {
        userDefaults = UserDefaults(suiteName: "group.UnUpsetDeveloper.UnUpset")!
    }
    
    var hasFamilyAccess: Bool {
        get { userDefaults.bool(forKey: hasFamilyAccessKey)}
        set { userDefaults.set(newValue, forKey: hasFamilyAccessKey) }
    }
    
    var savedApplications: [ApplicationToken]? {
        get { userDefaults.object(forKey: savedApplicationsKey) as? [ApplicationToken] }
        set { userDefaults.set(newValue, forKey: savedApplicationsKey) }
    }
    
    var savedCategories: [ActivityCategoryToken]? {
        get { userDefaults.object(forKey: savedCategoriesKey) as? [ActivityCategoryToken]}
        set { userDefaults.set(newValue, forKey: savedCategoriesKey) }
    }
}
