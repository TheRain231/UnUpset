//
//  MotionManager.swift
//  UnUpset
//
//  Created by Андрей Степанов on 16.01.2025.
//


import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private var lastAcceleration: CMAcceleration?
    @Published var isShaken = false
    
    init() {
        startMotionUpdates()
    }
    
    private func startMotionUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
                guard let self = self, let data = data else { return }
                
                if let last = self.lastAcceleration {
                    let deltaX = abs(last.x - data.acceleration.x)
                    let deltaY = abs(last.y - data.acceleration.y)
                    let deltaZ = abs(last.z - data.acceleration.z)
                    
                    if deltaX + deltaY + deltaZ > 8 { // Threshold for shaking
                        self.isShaken = true
                    }
                }
                self.lastAcceleration = data.acceleration
            }
        }
    }
}
