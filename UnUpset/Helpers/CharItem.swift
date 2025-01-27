//
//  charItem.swift
//  UnUpset
//
//  Created by Андрей Степанов on 26.01.2025.
//

import SwiftUI

struct charItem: Identifiable{
    let symbol: String
    let id = UUID()
    
    init(_ symbol: Character) {
        self.symbol = String(symbol)
    }
}
