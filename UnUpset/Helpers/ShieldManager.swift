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
    
    func shieldActivities() {
        // Очистка старых настроек
        store.clearAllSettings()
        
        // Загрузка сохраненных данных из sharedDefaults
        var applications = discouragedSelections.applicationTokens
        var categories = discouragedSelections.categoryTokens
        
        if applications.isEmpty {
            if let savedApplications = ShieldData.shared.savedApplications {
                applications = Set(savedApplications) // Преобразуем массив в множество
            }
        }
        
        if categories.isEmpty {
            if let savedCategories = ShieldData.shared.savedCategories {
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
        ShieldData.shared.savedApplications = Array(discouragedSelections.applicationTokens)
        ShieldData.shared.savedCategories = Array(discouragedSelections.categoryTokens)
    }
    
    func unshieldActivities() {
        // Сброс всех настроек
        store.clearAllSettings()
    }
}
