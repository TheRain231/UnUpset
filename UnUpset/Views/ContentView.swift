//
//  ContentView.swift
//  UnUpset
//
//  Created by Андрей Степанов on 07.11.2024.
//

import SwiftUI
import MessageUI

struct ContentView: View {
    @ObservedObject var shieldManager = ShieldManager.shared
    @StateObject private var motionManager = MotionManager()
    @AppStorage("selectedAppearance") var selectedAppearance = AppearanceOption.auto.rawValue
    @Environment(\.colorScheme) var systemColorScheme
    
    @State private var showFeedbackForm = false
    @State private var showConfirmationAlert = false
    @State private var showMailUnavailableAlert = false
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TimerView()
                .tabItem {
                    Label("Timer",
                          systemImage: "timer")
                }
                .tag(0)
            ShieldView()
                .tabItem {
                    Label("Settings",
                          systemImage: "gear")
                }
                .tag(1)
        }
        .applyTabViewStyle(shieldManager: shieldManager, motionManager: motionManager,
                           selectedAppearance: $selectedAppearance,
                           showFeedbackForm: $showFeedbackForm,
                           showConfirmationAlert: $showConfirmationAlert,
                           showMailUnavailableAlert: $showMailUnavailableAlert)
        .onOpenURL { url in
            if url.absoluteString == "unupset://openTimer" {
                selectedTab = 0
            }
        }
    }
}

extension View {
    @ViewBuilder
    func applyTabViewStyle(shieldManager: ShieldManager,
                           motionManager: MotionManager,
                           selectedAppearance: Binding<Int>,
                           showFeedbackForm: Binding<Bool>,
                           showConfirmationAlert: Binding<Bool>,
                           showMailUnavailableAlert: Binding<Bool>) -> some View {
        self
            .preferredColorScheme(AppearanceOption(rawValue: selectedAppearance.wrappedValue)?.colorScheme)
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
            .alert("Do you want to send feedback?", isPresented: showConfirmationAlert) {
                Button("Yes") {
                    if MFMailComposeViewController.canSendMail() {
                        showFeedbackForm.wrappedValue = true
                    } else {
                        showMailUnavailableAlert.wrappedValue = true
                    }
                }
                Button("No", role: .cancel) {}
            }
            .sheet(isPresented: showFeedbackForm) {
                FeedbackView(subject: "Feedback", recipient: "unupsetdeveloper@gmail.com")
                    .onAppear {
                        TimerManager.shared.stopTimer()
                    }
            }
            .alert(isPresented: showMailUnavailableAlert) {
                Alert(title: Text("Error"),
                      message: Text("The email client is currently unavailable. Please ensure that you have a mail app installed."),
                      dismissButton: .default(Text("OK")))
            }
            .onChange(of: motionManager.isShaken) { isShaken in
                if isShaken {
                    showConfirmationAlert.wrappedValue = true
                    print("has Shaken", showConfirmationAlert.wrappedValue)
                }
                motionManager.isShaken = false
            }
    }
}

func setupTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(named: "BackgroundColor")
    appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "AccentColor")
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "AccentColor")!]
    appearance.stackedLayoutAppearance.disabled.iconColor = UIColor(named: "unupsetGray")
    appearance.stackedLayoutAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor(named: "unupsetGray")!]
    
    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
    UITabBar.appearance().layer.borderWidth = 0.0
    UITabBar.appearance().clipsToBounds = true
}

#Preview {
    ContentView()
}
