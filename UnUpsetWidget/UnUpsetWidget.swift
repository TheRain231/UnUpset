//
//  UnUpsetWidget.swift
//  UnUpsetWidget
//
//  Created by Андрей Степанов on 26.01.2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TimerEntry {
        TimerEntry(date: Date(), remainingTime: TimerManager.shared.limit, isActive: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (TimerEntry) -> ()) {
        let isActive = TimerData.shared.isActive
        let remaining = isActive ?
                                max(TimerManager.shared.limit - Date().timeIntervalSince(TimerData.shared.startDate!), 0)
                                : TimerManager.shared.limit
        
        completion(TimerEntry(
            date: Date(),
            remainingTime: remaining,
            isActive: isActive
        ))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TimerEntry>) -> ()) {
        let currentDate = Date()
        var entries: [TimerEntry] = []
        let isActive = TimerData.shared.isActive
        
        if isActive, let startDate = TimerData.shared.startDate {
            let totalTime = TimerManager.shared.limit - currentDate.timeIntervalSince(startDate)
            
            for second in 0...Int(totalTime) {
                let entryDate = currentDate.addingTimeInterval(Double(second))
                let remaining = max(TimerManager.shared.limit - (entryDate.timeIntervalSince(startDate)), 0)
                entries.append(TimerEntry(
                    date: entryDate,
                    remainingTime: remaining,
                    isActive: remaining > 0
                ))
            }
            
            // Добавляем финальное состояние
            entries.append(TimerEntry(
                date: currentDate.addingTimeInterval(totalTime),
                remainingTime: 0,
                isActive: false
            ))
        } else {
            entries.append(TimerEntry(
                date: currentDate,
                remainingTime: TimerManager.shared.limit,
                isActive: false
            ))
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct UnUpsetWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        TimerView(entry: entry)
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
            if #available(iOS 17.0, *) {
                UnUpsetWidgetEntryView(entry: entry)
                    .containerBackground(Color("BackgroundColor"), for: .widget)
            } else {
                UnUpsetWidgetEntryView(entry: entry)
                    .padding()
                    .background(Color("BackgroundColor"))
            }
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
