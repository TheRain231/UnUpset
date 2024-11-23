//
//  ShieldView.swift
//  UnUpset
//
//  Created by Андрей Степанов on 21.11.2024.
//


import SwiftUI
import FamilyControls
import ManagedSettings

struct ShieldView: View {
    @ObservedObject var manager: ShieldManager
    @State private var showActivityPicker = false
    @State private var vm = ViewModel()
    
    var body: some View {
        VStack {
            Button("Stop the timer") {
                vm.stopTimerButtonAction()
            }
            .buttonStyle(.bordered)
        }
        .familyActivityPicker(isPresented: $showActivityPicker, selection: $manager.discouragedSelections)
    }
}
