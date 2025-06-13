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
    @ObservedObject private var vm = SettingsView.ViewModel()
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 6) {
    //            profile
                settings
                legal
                contactUs
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .background(Color("BackgroundColor"))
            .navigationTitle("Settings")
            .background(NavigationConfigurator { nc in
                nc.navigationBar.titleTextAttributes = [.foregroundColor : Color.text]
            })
            .alert("Notifications access denied",
                   isPresented: $vm.showAlertOnNotifications) {
                Button("Open settings", role: .destructive) {
                    vm.openSettings()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("You can enable access notifications in settings.")
            }
            .alert("Notifications access denied",
                   isPresented: $vm.showPickerUnavailableAlert) {
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("You can't select blocked apps while timer is active.")
            }
        }
    }
    
    var profile: some View {
        HStack{
            ZStack{
                let height: CGFloat = 60
                PersonIcon()
                    .fill(Color("unupsetGray"))
                    .frame(width: height, height: height)
                    .clipShape(.circle)
                Circle()
                    .stroke()
                    .frame(width: height, height: height)
            }
            VStack(alignment: .leading) {
                Text("User")
                    .font(.system(size: 22))
                Text("@user")
                    .font(.system(size: 13))
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8.5)
        .background{
            RoundedRectangle(cornerRadius: 13)
                .stroke()
        }
    }
    
    var settings: some View {
        VStack(spacing: 0) {
            Toggle(isOn: $vm.notifications) {
                HStack(spacing: 16) {
                    squaredIcon(systemName: "bell.fill")
                    Text("Reminders")
                        .padding(.vertical, 11)
                }
            }
            .tint(Color("FirstColor"))
            .padding(.horizontal, 16)
            
            divider
            
            HStack {
                HStack(spacing: 16) {
                    squaredIcon(systemName: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                    Text("Reminder frequency")
                }
                Spacer()
                Menu {
                    ForEach(ReminderFrequencyOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            vm.selectRemindersFrequency(option)
                        }
                    }
                } label: {
                    Text(vm.reminderFrequency.rawValue)
                        .foregroundStyle(Color("unupsetGray"))
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color("unupsetGray"))
                }
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 7)
            
            divider
            
            HStack {
                HStack(spacing: 16) {
                    squaredIcon(systemName: "timer")
                    Text("Timer length")
                }
                Spacer()
                Menu {
                    ForEach(TimerLenghtOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            vm.selectTimerLenght(option)
                        }
                    }
                } label: {
                    Text(vm.timerLenght.rawValue)
                        .foregroundStyle(Color("unupsetGray"))
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color("unupsetGray"))
                }
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 7)
            
            divider
            
            HStack(spacing: 16) {
                squaredIcon(systemName: "grid")
                Button {
                    vm.selectAppsAction()
                } label: {
                    Text("Select Apps")
                        .padding(.vertical, 11)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            .padding(.horizontal, 16)
        }
        .foregroundStyle(.primary)
        .background{
            RoundedRectangle(cornerRadius: 13)
                .stroke()
        }
        .familyActivityPicker(isPresented: $vm.showActivityPicker, selection: $vm.shieldManager.discouragedSelections)
    }
    
    var legal: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 16) {
                    squaredIcon(systemName: "sun.max.fill")
                    Text("Appearance")
                        .padding(.vertical, 11)
                }
                Spacer()
                Menu {
                    ForEach(AppearanceOption.allCases, id: \.self) { option in
                        Button(option.title) {
                            vm.selectAppearance(option)
                        }
                    }
                } label: {
                    Text(AppearanceOption(rawValue: vm.selectedAppearance)?.title ?? "Auto")
                        .foregroundStyle(Color("unupsetGray"))
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color("unupsetGray"))
                }
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            
            divider
            
            HStack(spacing: 16) {
                squaredIcon(systemName: "star.fill", isStared: true)
                Button {
                    requestReview()
                } label: {
                    Text("Rate the App")
                        .padding(.vertical, 11)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .foregroundStyle(.primary)
            
            divider
            
            HStack(spacing: 16) {
                squaredIcon(systemName: "hand.raised.fill")
                Link(destination: URL(string: "https://www.freeprivacypolicy.com/live/3e8da7a0-100d-4d21-8e8d-c7a5be00bc1b")!) {
                    Text("Privacy Policy")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 11)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
        }
        .background{
            RoundedRectangle(cornerRadius: 13)
                .stroke()
        }
        .padding(.top, 10)
    }
    
    var divider: some View {
        Divider()
            .overlay(Color("unupsetGray"))
            .padding(.horizontal, 16)
            .padding(.leading, 46)
    }
    
    var contactUs: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Keep in Touch")
                .font(.title2)
            let height: CGFloat = 40
            HStack{
                Link(destination: URL(string: "https://t.me/unupset_official")!) {
                    ZStack{
                        Circle()
                            .stroke()
                            .frame(width: height, height: height)
                        TelegramIcon()
                            .frame(width: height * 19 / 40, height: height * 17 / 40)
                            .offset(x: -2) // only for this image
                    }
                }
                Button {
                    vm.mailButtonAction()
                } label: {
                    ZStack{
                        Circle()
                            .stroke()
                            .frame(width: height, height: height)
                        Image(systemName: "envelope.fill")
                            .resizable()
                            .frame(width: height * 23.2 / 40, height: height * 16.8 / 40)
                    }
                }
            }
            .sheet(isPresented: $vm.showFeedbackForm) {
                FeedbackView(subject: "Feedback", recipient: "unupsetdeveloper@gmail.com")
            }
            .alert(isPresented: $vm.showMailUnavailableAlert) {
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

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
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
