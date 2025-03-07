//
//  FamilyPermissionsSheet.swift
//  UnUpset
//
//  Created by Андрей Степанов on 06.03.2025.
//

import SwiftUI

struct FamilyPermissionsSheet: View {
    @Binding var showSheet: Bool
    var onDismiss: () -> Void

    let contentRatio = 378.0 / 362.5
    
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
                    Text("Access")
                        .font(.system(size: 28, weight: .bold))
                    Text("You must grant access to screen time for your application to work. UnUpset will not have access to your application list or usage data.")
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    UnUpsetIcon()
                        .frame(width: proxy.size.width / 4.18, height: proxy.size.height / 9.43)
                        
                    Spacer()
                    
                    Button {
                        Task {
                            showSheet = false
                            _ = await ShieldManager.shared.requestAuthorization()
                            onDismiss()
                        }
                    } label: {
                        Text("Continue")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(lineWidth: 1)
                            }
                    }
                    .buttonStyle(.plain)
                }
                .padding(32)
                .aspectRatio(contentRatio, contentMode: .fit)
                .padding()
            }
        }
    }
}

#Preview {
    FamilyPermissionsSheet(showSheet: .constant(true), onDismiss: {})
}
