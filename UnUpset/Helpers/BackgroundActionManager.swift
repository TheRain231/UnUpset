//
//  BackgroundActionManager.swift
//  UnUpset
//
//  Created by Андрей Степанов on 14.12.2024.
//

import BackgroundTasks
    
func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: "removeLimit")
    request.earliestBeginDate = .now.addingTimeInterval(TimeInterval(TimerViewModel.shared.remainingTime))
    try? BGTaskScheduler.shared.submit(request)
}
