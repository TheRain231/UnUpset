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
    private let savedWebDomainCategoriesKey = "savedWebDomainCategories"
    private let hasFamilyAccessKey = "hasFamilyAccess"
    
    private init() {
        userDefaults = UserDefaults(suiteName: "group.UnUpsetDeveloper.UnUpset")!
    }
    
    var hasFamilyAccess: Bool {
        get { userDefaults.bool(forKey: hasFamilyAccessKey)}
        set { userDefaults.set(newValue, forKey: hasFamilyAccessKey) }
    }
    
    var savedApplications: [ApplicationToken] {
        get { userDefaults.loadCodable([ApplicationToken].self, forKey: savedApplicationsKey) ?? [] }
        set { userDefaults.saveCodable(newValue, forKey: savedApplicationsKey) }
    }
    
    var savedCategories: [ActivityCategoryToken] {
        get { userDefaults.loadCodable([ActivityCategoryToken].self, forKey: savedCategoriesKey) ?? [] }
        set { userDefaults.saveCodable(newValue, forKey: savedCategoriesKey) }
    }
    
    var savedWebDomainCategories: [WebDomainToken] {
        get { userDefaults.loadCodable([WebDomainToken].self, forKey: savedWebDomainCategoriesKey) ?? [] }
        set { userDefaults.saveCodable(newValue, forKey: savedWebDomainCategoriesKey) }
    }
}


extension UserDefaults {
    func saveCodable<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            self.set(encoded, forKey: key)
        }
    }

    func loadCodable<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = self.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
