//
//  ShieldManager.swift
//  UnUpset
//
//  Created by Андрей Степанов on 21.11.2024.
//


import SwiftUI
import FamilyControls
import ManagedSettings

class ShieldManager: ObservableObject {
    static let shared = ShieldManager()
    
    @Published var discouragedSelections = FamilyActivitySelection()
    
    private let store = ManagedSettingsStore()
    private let savedApplicationsKey = "savedApplications"
    private let savedCategoriesKey = "savedCategories"
    
    func shieldActivities() {
        // Очистка старых настроек
        store.clearAllSettings()
        
        // Установка новых настроек
        var applications = discouragedSelections.applicationTokens
        var categories = discouragedSelections.categoryTokens
        
        if applications.isEmpty{
            applications = UserDefaults.standard.object(forKey: savedApplicationsKey) as? Set<ApplicationToken> ?? []
        }
        if categories.isEmpty{
            categories = UserDefaults.standard.object(forKey: savedCategoriesKey) as? Set<ActivityCategoryToken> ?? []
        }
        
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = categories.isEmpty ? .all() : .specific(categories)
        store.shield.webDomainCategories = categories.isEmpty ? .all() : .specific(categories)
    }
    
    func unshieldActivities() {
        // Сброс всех настроек
        store.clearAllSettings()
    }
}
