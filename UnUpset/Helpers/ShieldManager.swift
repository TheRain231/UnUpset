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
    private let sharedDefaults = UserDefaults(suiteName: "group.UnUpsetDeveloper.UnUpset")
    private let savedApplicationsKey = "savedApplications"
    private let savedCategoriesKey = "savedCategories"
    
    func shieldActivities() {
        // Очистка старых настроек
        store.clearAllSettings()
        
        // Загрузка сохраненных данных из sharedDefaults
        var applications = discouragedSelections.applicationTokens
        var categories = discouragedSelections.categoryTokens
        
        if applications.isEmpty {
            if let savedApplications = sharedDefaults?.object(forKey: savedApplicationsKey) as? [ApplicationToken] {
                applications = Set(savedApplications) // Преобразуем массив в множество
            }
        }
        
        if categories.isEmpty {
            if let savedCategories = sharedDefaults?.object(forKey: savedCategoriesKey) as? [ActivityCategoryToken] {
                categories = Set(savedCategories) // Преобразуем массив в множество
            }
        }
        
        // Установка новых настроек
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = categories.isEmpty ? .all() : .specific(categories)
        store.shield.webDomainCategories = categories.isEmpty ? .all() : .specific(categories)
    }
    
    func saveDiscouragedSelections() {
        // Сохранение настроек в sharedDefaults
        sharedDefaults?.set(Array(discouragedSelections.applicationTokens), forKey: savedApplicationsKey)
        sharedDefaults?.set(Array(discouragedSelections.categoryTokens), forKey: savedCategoriesKey)
    }
    
    func unshieldActivities() {
        // Сброс всех настроек
        store.clearAllSettings()
    }
}
