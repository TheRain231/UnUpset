//
//  HapticEngine.swift
//  UnUpset
//
//  Created by Андрей Степанов on 13.11.2024.
//

import CoreHaptics

class HapticEngine {
    static let shared = HapticEngine()
    
    var engine: CHHapticEngine?
    
    init(){
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func playXY() {
        // Ensure the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let short1 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0)
        let short2 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0.2)
        let short3 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0.4)
        let short4 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0.6)
        
        let short5 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0.8)
        let short6 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 1.0)
        let long1 = CHHapticEvent(eventType: .hapticContinuous, parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(0.8))], relativeTime: 1.2, duration: 0.5)

        let intensityCurve = CHHapticParameterCurve(parameterID: .hapticIntensityControl,
                                                        controlPoints: [
                                                            CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 0.6),
                                                            CHHapticParameterCurve.ControlPoint(relativeTime: 1.45, value: 0.5),
                                                            CHHapticParameterCurve.ControlPoint(relativeTime: 1.7, value: 1.0)
                                                        ],
                                                        relativeTime: 0)
        
        do {
            let pattern = try CHHapticPattern(events: [short1, short2, short3, short4, short5, short6, long1], parameterCurves: [intensityCurve])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}
