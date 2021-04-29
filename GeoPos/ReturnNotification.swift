//
//  ReturnNotification.swift
//  GeoPos
//
//  Created by Matthew on 22.04.2021.
//  Copyright © 2021 Ostagram Inc. All rights reserved.
//

import Foundation
import UserNotifications

final class ReturnNotification {
    let timeInterval = 60.0 * 30 // 30  minutes
    let notificationIdentifier = "ReturnNotificationID"
    
    
    
    private func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Hey"
        content.subtitle = "man"
        content.body = "Вернитесь, я все прощу"
        content.badge = 1
        return content
    }
    
    private func makeIntervalNotificatioTrigger() -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )
    }
    
    func sendNotificatioRequest() {
        let request = UNNotificationRequest(
            identifier: notificationIdentifier,
            content: makeNotificationContent(),
            trigger: makeIntervalNotificatioTrigger()
        )
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeNotificatioRequest() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }
}
