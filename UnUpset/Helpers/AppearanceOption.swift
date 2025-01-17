//
//  AppearanceOption.swift
//  UnUpset
//
//  Created by Андрей Степанов on 17.01.2025.
//


import SwiftUI

enum AppearanceOption: Int, CaseIterable {
    case auto = 0
    case light = 1
    case dark = 2

    var title: String {
        switch self {
        case .auto: return "Auto"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .auto: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}