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

        func stopTimerButtonAction(){
            NotificationCenter.default.post(name: .timerStop, object: nil)
        }
        
        func selectAppearance(_ option: AppearanceOption){
            selectedAppearance = option.rawValue
        }
    }
}

extension Notification.Name {
    static let timerStop = Notification.Name("timerStop")
}
