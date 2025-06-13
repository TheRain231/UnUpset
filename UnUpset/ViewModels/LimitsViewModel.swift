//
//  LimitsViewModel.swift
//  UnUpset
//
//  Created by Андрей Степанов on 02.06.2025.
//

import SwiftUI

extension LimitsView {
    final class ViewModel: ObservableObject {
        @Published var limits: [String] = []
        @Published var isAddingSheetPresented: Bool = false
        @Published var selectedDate: Date = .now
        @Published var limitName: String = ""
        
        func showSheetButton() {
            isAddingSheetPresented = true
        }
    }
}
