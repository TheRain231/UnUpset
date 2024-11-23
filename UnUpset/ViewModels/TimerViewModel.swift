//
//  TimerViewModel.swift
//  UnUpset
//
//  Created by Андрей Степанов on 07.11.2024.
//

import Foundation
import SwiftUI

extension TimerView{
    
    @Observable
    final class ViewModel {
        // MARK: Properties
        private(set) var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        private(set) var isActive: Bool = false
        private(set) var progress: CGFloat = 0.0
        private var count = 0 {
            didSet {
                self.secondsLast = self.limit - self.count
                self.progress = CGFloat(self.count) / CGFloat(limit)
            }
        }
        
        private(set) var secondsLast: Int = 0
        
        //limit in seconds
        let limit: Int = 5 * 60
        
        // MARK: Init
        init(){
            self.secondsLast = self.limit
        }
        
        // MARK: Functions
        func cycle() {
            if self.isActive{
                if self.count < limit{
                    self.count += 1
                } else {
                    self.pause()
                }
            }
        }
        
        func pause(){
            self.isActive = false
            self.count = 0
        }
        
        func startButtonAction(){
            if !self.isActive{
                if self.count >= limit{
                    self.count = 0
                    self.progress = 0
                }
                self.isActive = true
            }
        }
        
        func restartButtonAction(){
            self.count = 0
            self.progress = 0
        }
        
        // MARK: UI helpers
        
        func stringMinutes() -> String {
            String(format: "%01i", self.secondsLast / 60)
        }
        
        func stringSeconds() -> [charItem] {
            var arr: [charItem] = []
            let secondsInString = String(format: "%02i", max(self.secondsLast % 60, 0))
            
            for symb in secondsInString{
                arr.append(charItem(symb))
            }
            
            return arr
        }
    }
}

struct charItem: Identifiable{
    let symbol: String
    let id = UUID()
    
    init(_ symbol: Character) {
        self.symbol = String(symbol)
    }
}
