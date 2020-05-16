//
//  TaskModel.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 5/4/20.
//  Copyright © 2020 Левкутник Дмитрий. All rights reserved.
//

import Foundation
import CloudKit

class TaskModel {
    var name: String
    var notes: String
    var notification: Bool
    var notificationIdentifier: String
    var repeatFrequency: String
    var timeOfEnd: Date
    var timeOfStart: Date
    var url: String
    var id: String
    
    init(record: CKRecord) {
        self.name = record.value(forKey: "name") as! String
        self.notes = record.value(forKey: "notes") as! String
        self.notification = (record.value(forKey: "notification") as! Double) == 1 ? true : false
        self.notificationIdentifier = record.value(forKey: "notificationIdentifier") as! String
        self.repeatFrequency = record.value(forKey: "repeatFrequency") as! String
        self.timeOfEnd = record.value(forKey: "timeOfEnd") as! Date
        self.timeOfStart = record.value(forKey: "timeOfStart") as! Date
        self.url = record.value(forKey: "url") as! String
        self.id = record.recordID.recordName
    }
    
 
}
