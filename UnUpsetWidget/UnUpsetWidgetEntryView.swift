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
    var entry: Provider.Entry

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
        .buttonStyle(PlayButtonStyle(isActive: entry.isActive))
        .animation(.smooth, value: entry.remainingTime)
    }
    
    @ViewBuilder
    func countDown(fontSize: CGFloat) -> some View {
        HStack(alignment: .center, spacing: 0) {
            Text(stringMinutes())
                .font(.system(size: fontSize, weight: .light))
                .frame(width: fontSize * 0.6, alignment: .trailing)
            Text(":")
                .font(.system(size: fontSize, weight: .light))
                .offset(y: -fontSize * 0.1)
            //symbol: charItem, confirms to Identfiable
            ForEach(stringSeconds()) { symbol in
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
                .trim(from: 0.0, to: min(1.0 - (entry.remainingTime / TimerManager.shared.limit), 1.0))
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
        .animation(.linear(duration: 1.0), value: entry.remainingTime)
        
    }
    
    func stringMinutes() -> String {
        return String(format: "%01i", Int(entry.remainingTime) / 60)
    }
    
    func stringSeconds() -> [charItem] {
        var arr: [charItem] = []
        let secondsInString = String(format: "%02i", Int(entry.remainingTime) % 60, 0)
        
        for symb in secondsInString {
            arr.append(charItem(symb))
        }
        
        return arr
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
