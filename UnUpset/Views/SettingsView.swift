//
//  SettingsView.swift
//  UnUpset
//
//  Created by Андрей Степанов on 21.11.2024.
//


import SwiftUI
import FamilyControls
import ManagedSettings
import MessageUI
import StoreKit

struct SettingsView: View {
    @StateObject private var viewModel = SettingsView.ViewModel()
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    timerSettingsSection
                    appSettingsSection
                    contactSection
                        .listRowBackground(Color.clear)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .navigationTitle("Settings")
            .modifier(alertsModifier(viewModel: viewModel))
        }
    }
    
    private var timerSettingsSection: some View {
        Section {
            settingsRow(title: "Reminders", systemImage: "bell.fill", content:  {
                Toggle(isOn: $viewModel.notifications) {}
                    .tint(.first)
            })
            
            settingsRow(title: "Reminder Frequency", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90", content:  {
                Menu {
                    ForEach(ReminderFrequencyOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            viewModel.selectRemindersFrequency(option)
                        }
                    }
                } label: {
                    Text(viewModel.reminderFrequency.rawValue)
                        .foregroundStyle(.secondaryText)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.unupsetGray)
                }
            })
            
            settingsRow(title: "Timer Lenght", systemImage: "timer", content:  {
                Menu {
                    ForEach(TimerLenghtOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            viewModel.selectTimerLenght(option)
                        }
                    }
                } label: {
                    Text(viewModel.timerLenght.rawValue)
                        .foregroundStyle(.secondaryText)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.unupsetGray)
                }
            })
            settingsRow(title: "Select Apps", systemImage: "square.grid.3x3.fill", subtitle: "Pick apps to block during focus.", action:  {
                viewModel.selectAppsAction()
            })
        }
        .familyActivityPicker(isPresented: $viewModel.showActivityPicker, selection: $viewModel.shieldManager.discouragedSelections)
    }
    
    private var appSettingsSection: some View {
        Section {
            settingsRow(title: "Appearance", systemImage: "sun.max.fill", content:  {
                Menu {
                    ForEach(AppearanceOption.allCases, id: \.self) { option in
                        Button(option.title) {
                            viewModel.selectAppearance(option)
                        }
                    }
                } label: {
                    Text(AppearanceOption(rawValue: viewModel.selectedAppearance)?.title ?? "Auto")
                        .foregroundStyle(.secondaryText)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.unupsetGray)
                }
            })
            
//            settingsRow(title: "Language", systemImage: "globe")
            
            settingsRow(title: "Rate the App", systemImage: "star.fill", isStared: true, action: {
                if let url = URL(string: "https://apps.apple.com/app/id6738584234") {
                    openURL(url)
                }
            })
            
            settingsRow(title: "Privacy Policy", systemImage: "shield.lefthalf.filled", action: {
                if let url = URL(string: "https://www.freeprivacypolicy.com/live/3e8da7a0-100d-4d21-8e8d-c7a5be00bc1b") {
                    openURL(url)
                }
            })
        }
    }
    
    private var contactSection: some View {
        let iconHeight: CGFloat = 40

        return VStack(alignment: .leading, spacing: 0) {
            Text("Keep in Touch")
                .font(.title2)
                .fontWeight(.bold)
            HStack{
                Link(destination: URL(string: "https://t.me/unupset_official")!) {
                    ZStack{
                        Circle()
                            .foregroundStyle(Color.background)
                            .frame(width: iconHeight, height: iconHeight)
                        TelegramIcon()
                            .frame(width: iconHeight * 19 / 40, height: iconHeight * 17 / 40)
                            .offset(x: -2) // only for this image
                    }
                }
                Button {
                    viewModel.mailButtonAction()
                } label: {
                    ZStack{
                        Circle()
                            .foregroundStyle(Color.background)
                            .frame(width: iconHeight, height: iconHeight)
                        Image(systemName: "envelope.fill")
                            .resizable()
                            .frame(width: iconHeight * 23.2 / 40, height: iconHeight * 16.8 / 40)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showFeedbackForm) {
                FeedbackView(subject: "Feedback", recipient: "unupsetdeveloper@gmail.com")
            }
            .alert(isPresented: $viewModel.showMailUnavailableAlert) {
                Alert(title: Text("Error"),
                      message: Text("The email client is currently unavailable. Please ensure that you have a mail app installed."),
                      dismissButton: .default(Text("OK")))
            }
            .padding(.vertical, 5)
            .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Helpers Extension
extension SettingsView {
    private func settingsRow(
        title: String,
        systemImage: String,
        isStared: Bool = false,
        subtitle: String? = nil,
        action: (() -> ())? = nil,
        @ViewBuilder content: @escaping () -> some View = {
            EmptyView()
        }
    ) -> some View {
        HStack(spacing: 16) {
            squaredIcon(systemName: systemImage, isStared: isStared)
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondaryText)
                }
            }
            
            Spacer()
            
            content()
        }.onTapGesture {
            if let action {
                action()
            }
        }
    }
    
    private struct alertsModifier: ViewModifier {
        @ObservedObject var viewModel: SettingsView.ViewModel
        
        func body(content: Content) -> some View {
            content
                .alert("Notifications access denied",
                       isPresented: $viewModel.showAlertOnNotifications) {
                    Button("Open settings", role: .destructive) {
                        viewModel.openSettings()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("You can enable access notifications in settings.")
                }
                .alert("Notifications access denied",
                       isPresented: $viewModel.showPickerUnavailableAlert) {
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("You can't select blocked apps while timer is active.")
                }
        }
    }
}

func squaredIcon(systemName: String, isStared: Bool = false) -> some View {
    let height: CGFloat = 30
    return ZStack {
        RoundedRectangle(cornerRadius: 7)
            .foregroundStyle(isStared ? .accent : .unupsetGray)
            .frame(width: height, height: height)
        Image(systemName: systemName)
            .foregroundStyle(Color.icon)
    }
}

#Preview {
    SettingsView()
}
