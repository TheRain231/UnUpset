//
//  UnUpsetWidget.swift
//  UnUpsetWidget
//
//  Created by Андрей Степанов on 26.01.2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private let defaults = UserDefaults(suiteName: "group.UnUpsetDeveloper.UnUpset")!
    
    func placeholder(in context: Context) -> TimerEntry {
        TimerEntry(date: Date(), remainingTime: 5 * 60, isActive: false)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TimerEntry) -> ()) {
        let pendingLimit = defaults.double(forKey: "pendingLimit")
        let isActive = defaults.bool(forKey: "TimerIsActive")
        let startDate = defaults.object(forKey: "TimerStartDate") as? Date ?? Date()
        
        let remaining = calculateRemainingTime(startDate: startDate,
                                             pendingLimit: pendingLimit,
                                             isActive: isActive)
        
        completion(TimerEntry(
            date: Date(),
            remainingTime: remaining,
            isActive: isActive && remaining > 0
        ))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TimerEntry>) -> ()) {
        let pendingLimit = defaults.double(forKey: "pendingLimit")
        let isActive = defaults.bool(forKey: "TimerIsActive")
        let startDate = defaults.object(forKey: "TimerStartDate") as? Date ?? Date()
        
        var entries: [TimerEntry] = []
        let currentDate = Date()
        
        if isActive {
            let elapsed = currentDate.timeIntervalSince(startDate)
            let remainingTotal = pendingLimit - elapsed
            
            if remainingTotal > 0 {
                // Генерируем записи с шагом в 1 секунду, но не более 60 на один запрос
                let entriesCount = min(Int(remainingTotal), 60)
                for i in 0..<entriesCount {
                    let entryDate = currentDate.addingTimeInterval(Double(i))
                    let elapsed = entryDate.timeIntervalSince(startDate)
                    let remaining = max(pendingLimit - elapsed, 0)
                    
                    entries.append(TimerEntry(
                        date: entryDate,
                        remainingTime: remaining,
                        isActive: remaining > 0
                    ))
                }
                
                // Планируем следующее обновление через 60 секунд или раньше
                let nextUpdateDate = currentDate.addingTimeInterval(Double(entriesCount))
                entries.append(TimerEntry(
                    date: nextUpdateDate,
                    remainingTime: max(pendingLimit - nextUpdateDate.timeIntervalSince(startDate), 0),
                    isActive: true
                ))
            } else {
                entries.append(TimerEntry(
                    date: currentDate,
                    remainingTime: 0,
                    isActive: false
                ))
            }
        } else {
            entries.append(TimerEntry(
                date: currentDate,
                remainingTime: pendingLimit,
                isActive: false
            ))
        }
        
        let timeline = Timeline(entries: entries, policy: .after(entries.last?.date ?? currentDate))
        completion(timeline)
    }
    
    private func calculateRemainingTime(startDate: Date, pendingLimit: Double, isActive: Bool) -> Double {
        guard isActive else { return pendingLimit }
        let elapsed = Date().timeIntervalSince(startDate)
        return max(pendingLimit - elapsed, 0)
    }
}

struct UnUpsetWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        TimerView(entry: entry)
            .widgetURL(URL(string: "unupset://openTimer"))
    }
}

struct TimerEntry: TimelineEntry {
    let date: Date
    let remainingTime: TimeInterval
    let isActive: Bool
    
    init(date: Date, remainingTime: TimeInterval, isActive: Bool) {
        self.date = date
        self.remainingTime = remainingTime
        self.isActive = isActive
    }
}

struct UnUpsetWidget: Widget {
    let kind: String = "UnUpsetWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            UnUpsetWidgetEntryView(entry: entry)
                .containerBackground(Color("BackgroundColor"), for: .widget)
        }
        .configurationDisplayName("Timer")
        .description("Timer widget")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    UnUpsetWidget()
} timeline: {
    TimerEntry(date: .now, remainingTime: TimerManager.shared.limit, isActive: false)
}
