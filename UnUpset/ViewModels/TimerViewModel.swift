//
//  TimerViewModel.swift
//  UnUpset
//
//  Created by Андрей Степанов on 07.11.2024.
//

import Foundation
import SwiftUI
import Combine

extension TimerView {
    final class ViewModel: ObservableObject {
        // MARK: Properties
        @Published var isFirstAppearance: Bool = true
        @ObservedObject var timerManager = TimerManager.shared
        @Published var isActive: Bool = false
        @Published var progress: CGFloat = 0.0
        
        private var cancellableOnProgress: AnyCancellable?
        private var cancellableOnOpen: AnyCancellable?

        init() {
            timerManager.$isActive
                .assign(to: &$isActive) // Автоматически связывает значения
            timerManager.$progress
                .map { CGFloat($0) }
                .assign(to: &$progress)
            cancellableOnProgress = timerManager.$progress // Подписывается на обновления progress
                .sink { [weak self] newValue in
                    self?.isFirstAppearance = false
                    self?.cancellableOnProgress?.cancel()
                }
            cancellableOnOpen = NotificationCenter.default.publisher(for: .appOpened)
                .sink { [weak self] _ in
                    self?.loadState()
                }
        }
        
        
        // MARK: Functions
        func playButtonAction(){
            timerManager.startTimer()
            ShieldManager.shared.shieldActivities()
        }
        
        func loadState() {
            self.isFirstAppearance = true
            timerManager.loadState()
            cancellableOnProgress = timerManager.$progress
                .sink { [weak self] newValue in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self?.isFirstAppearance = false
                    }
                    self?.cancellableOnProgress?.cancel()
                }
        }
        
        // MARK: UI helpers
        func stringMinutes() -> String {
            return String(format: "%01i", Int(timerManager.remainingTime) / 60)
        }
        
        func stringSeconds() -> [charItem] {
            var arr: [charItem] = []
            let secondsInString = String(format: "%02i", Int(timerManager.remainingTime) % 60, 0)
            
            for symb in secondsInString {
                arr.append(charItem(symb))
            }
            
            return arr
        }
    }
}
