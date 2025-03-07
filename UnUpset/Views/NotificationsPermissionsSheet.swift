//
//  NotificationsPermissionsSheet.swift
//  UnUpset
//
//  Created by Андрей Степанов on 07.03.2025.
//

import SwiftUI

struct NotificationsPermissionsSheet: View {
    @Binding var showSheet: Bool
    @Environment(\.colorScheme) var colorScheme
    let contentRatio = CGFloat(378) / CGFloat(234)

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black.opacity(0.33)
                    .ignoresSafeArea()
                
                RoundedRectangle(cornerRadius: 40)
                    .aspectRatio(contentRatio, contentMode: .fit)
                    .padding()
                RoundedRectangle(cornerRadius: 40)
                    .aspectRatio(contentRatio, contentMode: .fit)
                    .foregroundStyle(Color("BackgroundColor"))
                    .padding()
                    .padding(1)
                
                VStack(spacing: 4) {
                    Text("Reminders")
                        .font(.system(size: 28, weight: .bold))
                    
                    Text("самый крутой текст эвер форевер")
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Button {
                        showSheet = false
                        NotificationManager.shared.requestNotificationAuthorization()
                    } label: {
                        Text("Allow")
                            .padding(14)
                            .frame(maxWidth: .infinity)
                            .background {
                                if (colorScheme == .light) {
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(lineWidth: 1)
                                        .background {
                                            RoundedRectangle(cornerRadius: 14)
                                                .foregroundStyle(Color("FirstColor"))
                                        }
                                } else if (colorScheme == .dark){
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(lineWidth: 1)
                                }
                            }
                    }
                    .foregroundStyle(colorScheme == .dark ? .first : .primary)
                    .buttonStyle(.plain)
                    
                    Button {
                        showSheet = false
                    } label: {
                        Text("I don't want to be productive")
                            .font(.system(size: 17))
                    }
                    .foregroundStyle(.secondaryText)
                    .padding(.top, 12)
                }
                .padding(34)
                .aspectRatio(contentRatio, contentMode: .fit)
                .padding()
            }
        }
    }
}

#Preview {
    NotificationsPermissionsSheet(showSheet: .constant(true))
}
