//
//  NotificationScheduler.swift
//  QamarDeen
//
//  Created by Mazyad Alabduljaleel on 1/19/17.
//  Copyright © 2017 Batoul Apps. All rights reserved.
//

import Foundation
import UIKit

/// responsible for wrapping the Local Notification APIs with
/// convenient access to manage the required reminders
final class NotificationScheduler {
    
    class var canScheduleAlerts: Bool {
        
        let app = UIApplication.shared
        if let settings = app.currentUserNotificationSettings , settings.types != UIUserNotificationType() {
            return true // settings enabled
        }
        
        let types: UIUserNotificationType = [.sound, .alert]
        let notifSettings = UIUserNotificationSettings(types: types, categories: nil)
        
        app.registerUserNotificationSettings(notifSettings)
        
        return false
    }
    
    class func scheduleNotifications(_ notifications: [NotificationMeta]) {
        
        guard canScheduleAlerts else {
            return
        }
        
        let app = UIApplication.shared
        app.cancelAllLocalNotifications()
        
        notifications
            .map { $0.localNotification }
            .forEach { app.scheduleLocalNotification($0) }
    }
}

/// MARK: converting Notifications to UILocalNotification

extension NotificationMeta {

    var localNotification: UILocalNotification {
        
        let localNotification = UILocalNotification()
        localNotification.alertBody = message
        localNotification.fireDate = date
        localNotification.repeatInterval = frequency
        
        return localNotification
    }
}
