//
//  TimerViewModel.swift
//  UnUpset
//
//  Created by Андрей Степанов on 07.11.2024.
//

import Foundation
import SwiftUI

    @Observable
    final class TimerViewModel {
        static let shared = TimerViewModel()
        
        // MARK: Properties
        private(set) var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        private(set) var isActive: Bool = false
        private(set) var progress: CGFloat = 0.0
        private var count = 0 {
            didSet {
                self.secondsLeft = self.limit - self.count
                self.progress = CGFloat(self.count) / CGFloat(limit)
            }
        }
        
        private(set) var secondsLeft: Int = 0
        
        //limit in seconds
        let limit: Int = 5 * 60
        
        var leftTime: Date = Date()
        
        // MARK: Init
        init(){
            self.secondsLeft = self.limit
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
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["TIMER"])

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
                
                performNotification()
            }
        }
        
        func restartButtonAction(){
            self.count = 0
            self.progress = 0
        }
        
        func addTime(_ time: Int){
            if time >= 0 {
                withAnimation{
                    self.count += time
                }
            } else {
                self.pause()
            }
        }
        
        // MARK: UI helpers
        
        func stringMinutes() -> String {
            String(format: "%01i", self.secondsLeft / 60)
        }
        
        func stringSeconds() -> [charItem] {
            var arr: [charItem] = []
            let secondsInString = String(format: "%02i", max(self.secondsLeft % 60, 0))
            
            for symb in secondsInString{
                arr.append(charItem(symb))
            }
            
            return arr
        }
        
        private func performNotification(){
            let content = UNMutableNotificationContent()
            content.title = "You did it!"
            content.body = "Open the app to unlock your phone"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(self.limit), repeats: false)
            
            let request = UNNotificationRequest(identifier: "TIMER", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                }
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
