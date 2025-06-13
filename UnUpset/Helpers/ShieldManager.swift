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
    
    struct ShieldTask: Identifiable {
        let id: UUID
        var selection: FamilyActivitySelection
        var isActive: Bool = false
    }

    @Published var shieldTasks: [ShieldTask] = []
    
    let center = AuthorizationCenter.shared
    private let store = ManagedSettingsStore()
    
    func requestAuthorization() async -> Bool {
        do {
            try await ShieldManager.shared.center.requestAuthorization(for: .individual)
            ShieldData.shared.hasFamilyAccess = true
            
            print("Family controlls enrolled")
            
            return true
        } catch {
            ShieldData.shared.hasFamilyAccess = false

            print("Failed to enroll individual user with error: \(error.localizedDescription)")
            return false
        }
    }
    
    init() {
        discouragedSelections.applicationTokens = Set(ShieldData.shared.savedApplications)
        discouragedSelections.categoryTokens = Set(ShieldData.shared.savedCategories)
        discouragedSelections.webDomainTokens = Set(ShieldData.shared.savedWebDomainCategories)
    }
    
    func updateCategories() {
        ShieldData.shared.savedApplications = Array(discouragedSelections.applicationTokens)
        ShieldData.shared.savedCategories = Array(discouragedSelections.categoryTokens)
        ShieldData.shared.savedWebDomainCategories = Array(discouragedSelections.webDomainTokens)
        
        if TimerData.shared.isActive {
            shieldActivities()
        }
    }
    
    func shieldActivities() {
        store.clearAllSettings()
        
        let applications = discouragedSelections.applicationTokens
        let categories = discouragedSelections.categoryTokens
        let websites = discouragedSelections.webDomainTokens
        
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = categories.isEmpty && applications.isEmpty ? .all() : .specific(categories)
        
        // Блокируем конкретные веб-домены
        store.shield.webDomains = websites.isEmpty ? nil : websites
    }
    
    func unshieldActivities() {
        // Сброс всех настроек
        store.clearAllSettings()
    }
    
    func startShield(for taskID: UUID) {
        guard let taskIndex = shieldTasks.firstIndex(where: { $0.id == taskID }) else { return }
        let task = shieldTasks[taskIndex]

        let taskStore = ManagedSettingsStore(named: ManagedSettingsStore.Name(rawValue: task.id.uuidString))

        let apps = task.selection.applicationTokens
        let cats = task.selection.categoryTokens
        let sites = task.selection.webDomainTokens

        taskStore.shield.applications = apps.isEmpty ? nil : apps
        taskStore.shield.applicationCategories = cats.isEmpty && apps.isEmpty ? .all() : .specific(cats)
        taskStore.shield.webDomains = sites.isEmpty ? nil : sites

        shieldTasks[taskIndex].isActive = true
    }

    func stopShield(for taskID: UUID) {
        guard let taskIndex = shieldTasks.firstIndex(where: { $0.id == taskID }) else { return }

        let taskStore = ManagedSettingsStore(named: ManagedSettingsStore.Name(rawValue: taskID.uuidString))
        taskStore.clearAllSettings()

        shieldTasks[taskIndex].isActive = false
    }
}
