//
//  UnUpsetWidgetEntryView.swift
//  UnUpset
//
//  Created by Андрей Степанов on 26.01.2025.
//

import SwiftUI
import Combine
import AppIntents


struct TimerView: View {
    @StateObject var vm = TimerView.ViewModel()
    private let lineWidth: CGFloat = 15.0
    
    var body: some View {
        GeometryReader { proxy in
            VStack{
                ZStack{
                    progressView
                    VStack(spacing: 0){
                        countDown(fontSize: 33.75)

                        playButton(fontSize: 36)
                    }
                    .offset(y: 3)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BackgroundColor"))
        }
    }
    
    @ViewBuilder
    func playButton(fontSize: CGFloat) -> some View {
        Button (intent: PlayButtonActionIntent()){
            Image(systemName: "play.fill")
                .font(.system(size: fontSize))
        }
        .buttonStyle(PlayButtonStyle(isActive: vm.isActive))
        .animation(.smooth, value: vm.progress)
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
                .trim(from: 0.0, to: 0.0001)
                .stroke(style: StrokeStyle(lineWidth: lineWidth,
                                           lineCap: .round, lineJoin: .round))
                .foregroundColor(Color("FirstColor"))
                .rotationEffect(Angle(degrees: 270))
        }
        .animation(vm.isFirstAppearance ? nil : .linear(duration: 1.0), value: vm.progress)
    }
}

extension TimerView{
    final class ViewModel: ObservableObject {
        // MARK: Properties
        @Published var isFirstAppearance: Bool = true
        @ObservedObject var timerManager = TimerManager.shared
        @Published var isActive: Bool = false
        @Published var progress: CGFloat = 0.0
        
        private var cancellableOnProgress: AnyCancellable?
        private var cancellableOnOpen: AnyCancellable?

        init() {
            timerManager.$isActive
                .assign(to: &$isActive) // Автоматически связывает значения
            timerManager.$progress
                .map { CGFloat($0) }
                .assign(to: &$progress)
            cancellableOnProgress = timerManager.$progress // Подписывается на обновления progress
                .sink { [weak self] newValue in
                    self?.isFirstAppearance = false
                    self?.cancellableOnProgress?.cancel()
                }
        }
        
        
        // MARK: Functions
        func playButtonAction(){
            timerManager.startTimer()
            ShieldManager.shared.shieldActivities()
        }
        
        func loadState() {
            self.isFirstAppearance = true
            timerManager.loadState()
            cancellableOnProgress = timerManager.$progress
                .sink { [weak self] newValue in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self?.isFirstAppearance = false
                    }
                    self?.cancellableOnProgress?.cancel()
                }
        }
        
        // MARK: UI helpers
        func stringMinutes() -> String {
            return String(format: "%01i", Int(timerManager.remainingTime) / 60)
        }
        
        func stringSeconds() -> [charItem] {
            var arr: [charItem] = []
            let secondsInString = String(format: "%02i", Int(timerManager.remainingTime) % 60, 0)
            
            for symb in secondsInString {
                arr.append(charItem(symb))
            }
            
            return arr
        }
    }
}

struct PlayButtonStyle: ButtonStyle {
    var isActive: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color("ButtonInactive"))
            .opacity(isActive ? 0.33 : 1)
    }
}
