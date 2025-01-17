//
//  ShieldViewModel.swift
//  UnUpset
//
//  Created by Андрей Степанов on 21.11.2024.
//

import Foundation

extension ShieldView {
    final class ViewModel: ObservableObject{
        func stopTimerButtonAction(){
            NotificationCenter.default.post(name: .timerStop, object: nil)
        }
    }
}

extension Notification.Name {
    static let timerStop = Notification.Name("timerStop")
}
