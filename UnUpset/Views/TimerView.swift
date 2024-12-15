//
//  TimerView.swift
//  UnUpset
//
//  Created by Андрей Степанов on 07.11.2024.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var manager: ShieldManager
    @State var vm: TimerViewModel = TimerViewModel.shared
    private let lineWidth: CGFloat = 24.0
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            VStack{
                ZStack{
                    progressView
                        .frame(width: size.height * 0.37,
                               height: size.height * 0.37)
                    countDown(fontSize: size.height * 0.128)
                }
                playButton
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(vm.timer) { (_) in
                vm.cycle()
            }
            .onReceive(NotificationCenter.default.publisher(for: .timerStop)) { _ in
                vm.pause()
            }
            .onChange(of: vm.isActive) { oldValue, newValue in
                if oldValue{
                    HapticEngine.shared.playXY()
                    manager.unshieldActivities()
                }
            }
        }
    }
    
    var playButton: some View {
        Button {
            vm.startButtonAction()
            manager.shieldActivities()
        } label: {
            Image(systemName: "play.fill")
                .font(.system(size: 70))
                .padding()
        }
        .buttonStyle(PlayButtonStyle(isActive: vm.isActive))
        .animation(.smooth, value: vm.secondsLeft)
    }
    
    @ViewBuilder
    func countDown(fontSize: CGFloat) -> some View {
        HStack(alignment: .center, spacing: 0) {
            Text(vm.stringMinutes())
                .font(.system(size: fontSize, weight: .light))
                .frame(width: fontSize * 0.6, alignment: .trailing)
            Text(":")
                .font(.system(size: fontSize, weight: .light))
                .offset(y: -fontSize * 0.1)
            //symbol: charItem, confirms to Identfiable
            ForEach(vm.stringSeconds()) { symbol in
                Text(symbol.symbol)
                    .font(.system(size: fontSize, weight: .light))
                    .frame(width: fontSize * 0.6)
            }
        }
    }
    
    var progressView: some View {
        ZStack {
            // Secondary circle
            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundColor(Color("SecondColor"))
            
            // Main circle
            Circle()
                .trim(from: 0.0, to: min(vm.progress, 1.0))
                .stroke(style: StrokeStyle(lineWidth: lineWidth,
                                           lineCap: .round, lineJoin: .round))
                .foregroundColor(Color("FirstColor"))
                .rotationEffect(Angle(degrees: 270))
            Circle()
                .trim(from: 0.0, to: 0.00001)
                .stroke(style: StrokeStyle(lineWidth: lineWidth,
                                           lineCap: .round, lineJoin: .round))
                .foregroundColor(Color("FirstColor"))
                .rotationEffect(Angle(degrees: 270))
        }
        .animation(.snappy(duration: 1.0), value: vm.progress)
    }
}

struct PlayButtonStyle: ButtonStyle {
    var isActive: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color(isActive ? "ButtonActive" : "ButtonInactive"))
    }
}

#Preview {
    ContentView(manager: ShieldManager())
}
