//
//  ContentView.swift
//  UnUpset
//
//  Created by Андрей Степанов on 07.11.2024.
//

import SwiftUI
import MessageUI

struct ContentView: View {
    @ObservedObject var manager: ShieldManager
    @StateObject private var motionManager = MotionManager()
    @AppStorage("selectedAppearance") var selectedAppearance = AppearanceOption.auto.rawValue
    @Environment(\.colorScheme) var systemColorScheme
    
    @State private var showFeedbackForm = false
    @State private var showConfirmationAlert = false
    @State private var showMailUnavailableAlert = false
    
    var body: some View {
        if #available(iOS 18.0, *) {
            TabView {
                Tab("Timer", systemImage: "timer") {
                    ZStack {
                        Color("BackgroundColor")
                            .ignoresSafeArea()
                        TimerView(manager: manager)
                    }
                }
                
                Tab("Settings", systemImage: "gear") {
                    ZStack {
                        Color("BackgroundColor")
                            .ignoresSafeArea()
                        ShieldView(manager: manager)
                    }
                }
                
            }
            .preferredColorScheme(AppearanceOption(rawValue: selectedAppearance)?.colorScheme)
            .environment(\.horizontalSizeClass, .compact)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(.primary)
                    .frame(height: 1)
                    .offset(y: -50)
            }
            .onAppear {
                setupTabBarAppearance()
            }
            .alert("Do you want to send feedback?", isPresented: $showConfirmationAlert) {
                Button("Yes") {
                    NotificationCenter.default.post(name: .timerStop, object: nil)
                    if MFMailComposeViewController.canSendMail() {
                        showFeedbackForm = true
                    } else {
                        showMailUnavailableAlert = true
                    }
                }
                Button("No", role: .cancel) {}
            }
            .sheet(isPresented: $showFeedbackForm) {
                FeedbackView(subject: "Feedback", recipient: "unupsetdeveloper@gmail.com")
            }
            .alert(isPresented: $showMailUnavailableAlert) {
                Alert(title: Text("Error"),
                      message: Text("The email client is currently unavailable. Please ensure that you have a mail app installed."),
                      dismissButton: .default(Text("ОК")))
            }
            .onChange(of: motionManager.isShaken) { _, isShaken in
                if isShaken{
                    showConfirmationAlert = true
                    print("has Shaken", showConfirmationAlert)
                }
                motionManager.isShaken = false
            }
        } else {
            TabView {
                ZStack {
                    Color("BackgroundColor")
                        .ignoresSafeArea()
                    TimerView(manager: manager)
                }
                .tabItem {
                    Label("Timer",
                          systemImage: "timer")
                }
                ZStack {
                    Color("BackgroundColor")
                        .ignoresSafeArea()
                    ShieldView(manager: manager)
                }
                .tabItem {
                    Label("Settings",
                          systemImage: "gear")
                }
            }
            .preferredColorScheme(AppearanceOption(rawValue: selectedAppearance)?.colorScheme)
            .environment(\.horizontalSizeClass, .compact)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(.primary)
                    .frame(height: 1)
                    .offset(y: -50)
            }
            .onAppear {
                setupTabBarAppearance()
            }
            .alert("Do you want to send feedback?", isPresented: $showConfirmationAlert) {
                Button("Yes") {
                    if MFMailComposeViewController.canSendMail() {
                        showFeedbackForm = true
                    } else {
                        showMailUnavailableAlert = true
                    }
                }
                Button("No", role: .cancel) {}
            }
            .sheet(isPresented: $showFeedbackForm) {
                FeedbackView(subject: "Feedback", recipient: "unupsetdeveloper@gmail.com")
                    .onAppear{
                        NotificationCenter.default.post(name: .timerStop, object: nil)
                    }
            }
            .alert(isPresented: $showMailUnavailableAlert) {
                Alert(title: Text("Error"),
                      message: Text("The email client is currently unavailable. Please ensure that you have a mail app installed."),
                      dismissButton: .default(Text("ОК")))
            }
            .onChange(of: motionManager.isShaken) { isShaken in
                if isShaken{
                    showConfirmationAlert = true
                    print("has Shaken", showConfirmationAlert)
                }
                motionManager.isShaken = false
            }
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
