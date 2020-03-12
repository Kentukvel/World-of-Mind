//
//  Notification Manager.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/13/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import Foundation

import UserNotifications

class NotificationManager {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func scheduleNotificationForTimeTable(with title: String, at date: Date, repeats: Repeat, identifier: String) {
        
        
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.sound = UNNotificationSound.default
        
        var triggerDate: DateComponents
        switch repeats {
        case .never:
            print("set notification")
            triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        case .everyDay:
            triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
        case .everyWeek:
            triggerDate = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: date)
        case .everyMonth:
            triggerDate = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
        case .everyYear:
            triggerDate = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: date)
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: repeats == .never)
        
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
    }
    
    
    func removeNotidication(withIdentifiers identifiers: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
