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
        TimerEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (TimerEntry) -> ()) {
        let entry = TimerEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TimerEntry>) -> ()) {
        var entries: [TimerEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = TimerEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct UnUpsetWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        TimerView()
    }
}

struct TimerEntry: TimelineEntry {
    let date: Date
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
    TimerEntry(date: .now)
}
