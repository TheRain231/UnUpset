//
//  ShieldView.swift
//  UnUpset
//
//  Created by Андрей Степанов on 21.11.2024.
//


import SwiftUI
import FamilyControls
import ManagedSettings
import MessageUI

struct ShieldView: View {
    @ObservedObject private var vm = ShieldView.ViewModel()
    
    var body: some View {
        VStack(spacing: 11) {
            profile
            settings
            contactUs
            
            Spacer()
        }
        .padding(.horizontal, 22)
        .background(Color("BackgroundColor"))
        .alert("Notifications access denied",
               isPresented: $vm.showAlertOnNotifications) {
                    Button("Open settings", role: .destructive) {
                        vm.openSettings()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("You can enable access notifications in settings.")
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
    
    var settings: some View{
        VStack(spacing: 0) {
            Toggle(isOn: $vm.notifications) {
                Text("Reminders")
                    .padding(.vertical, 11)
            }
            .tint(Color("FirstColor"))
            .padding(.horizontal, 16)
            
            Divider()
                .overlay(Color("unupsetGray"))
                .padding(.horizontal, 16)
            HStack {
                Text("Appearance")
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
            .padding(.vertical, 11)
            
            Divider()
                .overlay(Color("unupsetGray"))
                .padding(.horizontal, 16)
            Link("Privacy Policy",
                 destination: URL(string: "https://www.freeprivacypolicy.com/live/3e8da7a0-100d-4d21-8e8d-c7a5be00bc1b")!)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 11)
        }
        .background{
            RoundedRectangle(cornerRadius: 13)
                .stroke()
        }
    }
    
    var contactUs: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Contact Us")
                .font(.largeTitle)
                .bold()
                .offset(x: -2)
            HStack{
                Link(destination: URL(string: "https://t.me/unupset")!) {
                    ZStack{
                        let height: CGFloat = 50
                        Circle()
                            .stroke()
                            .frame(width: height, height: height)
                        TelegramIcon()
                            .frame(width: 21, height: 21)
                            .offset(x: -2) // only for this image
                    }
                }
                Link(destination: URL(string: "tel://+79684652728")!) {
                    ZStack{
                        let height: CGFloat = 50
                        Circle()
                            .stroke()
                            .frame(width: height, height: height)
                        Image(systemName: "phone.fill")
                            .resizable()
                            .frame(width: 21, height: 21)
                    }
                }
            }
            .padding(.vertical, 11)
            .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ShieldView()
}
