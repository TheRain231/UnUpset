//
//  ContentView.swift
//  UnUpset
//
//  Created by Андрей Степанов on 07.11.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager: ShieldManager
    var body: some View {
        TabView {
            Tab("Timer", systemImage: "timer") {
                ZStack {
                    Color("BackgroundColor")
                        .ignoresSafeArea()
                    TimerView(manager: manager)
                }
            }
            
            Tab("Profile", systemImage: "person") {
                ZStack {
                    Color("BackgroundColor")
                        .ignoresSafeArea()
                    ShieldView(manager: manager)
                }
            }
        }
        .environment(\.horizontalSizeClass, .compact)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color("ButtonActive"))
                .frame(height: 3)
                .offset(y: -50)
        }
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground() // Sets an opaque background color
        appearance.backgroundColor = UIColor(named: "BackgroundColor")
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "AccentColor") // Color for selected tab icons
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "AccentColor")!]  // Color for selected tab text
        
        appearance.stackedLayoutAppearance.disabled.iconColor = UIColor(named: "ButtonActive") // Color for disabled tab icons
        appearance.stackedLayoutAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor(named: "ButtonActive")!] // Color for disabled tab text
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
    }
}

#Preview {
    ContentView(manager: ShieldManager())
}
