//
//  ShieldViewModel.swift
//  UnUpset
//
//  Created by Андрей Степанов on 21.11.2024.
//

import Foundation
import SwiftUI

extension ShieldView {
    final class ViewModel: ObservableObject{
        @ObservedObject var shieldManager = ShieldManager.shared
        @AppStorage("selectedAppearance") var selectedAppearance = AppearanceOption.auto.rawValue

        func selectAppearance(_ option: AppearanceOption){
            selectedAppearance = option.rawValue
        }
    }
}
