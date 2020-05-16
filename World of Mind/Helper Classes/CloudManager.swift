//
//  CloudManager.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 4/28/20.
//  Copyright © 2020 Левкутник Дмитрий. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

class CloudManager {
    
    private static let privateCloudDatabase = CKContainer.default().privateCloudDatabase
    //private static let publicDatabase = CKContainer.default().publicCloudDatabase
    
    static func saveDataToCloud(toDoList: ToDoList, closure: @escaping (String) -> ()) {
        let record = CKRecord(recordType: "ToDoList")
        record.setValue(toDoList.dateOfLastUpdate, forKey: "dateOfLastUpdate")
        record.setValue(toDoList.name, forKey: "name")
        
        
        privateCloudDatabase.save(record) { (newRecord, error) in
            if let error = error { print(error); return }
            if let newRecord = newRecord {
                closure(newRecord.recordID.recordName)
            }
            
        }
    }
    
    static func saveDataToCloud(finance: Finance, closure: @escaping (String) -> ()) {
        let record = CKRecord(recordType: "Finance")
        
        record.setValue(finance.cost, forKey: "cost")
        record.setValue(finance.name, forKey: "name")
        record.setValue(finance.date, forKey: "date")
        record.setValue(finance.profit ? 1 : 0, forKey: "profit")
        
        
        privateCloudDatabase.save(record) { (newRecord, error) in
            if let error = error { print(error); return }
            if let newRecord = newRecord {
                closure(newRecord.recordID.recordName)
            }
            
        }
    }
    
    static func saveDataToCloud(toDoTask: ToDoTask, for list: ToDoList, closure: @escaping (String) -> ()) {
        let record = CKRecord(recordType: "ToDoTask")
        record.setValue(toDoTask.done ? 1 : 0, forKey: "done")
        record.setValue(toDoTask.name, forKey: "name")
        record.setValue(list.id, forKey: "toDoListID")
        
        privateCloudDatabase.save(record) { (newRecord, error) in
            if let error = error { print(error); return }
            if let newRecord = newRecord {
                closure(newRecord.recordID.recordName)
            }
            
        }
    }
    
    static func saveDataToCloud(task: Task, closure: @escaping (String) -> ()) {
        let record = CKRecord(recordType: "Task")
        record.setValue(task.notes, forKey: "notes")
        record.setValue(task.name, forKey: "name")
        record.setValue(task.notification ? 1 : 0, forKey: "notification")
        record.setValue(task.notificationIdentifier, forKey: "notificationIdentifier")
        record.setValue(task.repeatFrequency, forKey: "repeatFrequency")
        record.setValue(task.timeOfEnd, forKey: "timeOfEnd")
        record.setValue(task.timeOfStart, forKey: "timeOfStart")
        record.setValue(task.url, forKey: "url")
        
        privateCloudDatabase.save(record) { (newRecord, error) in
            if let error = error { print(error); return }
            if let newRecord = newRecord {
                closure(newRecord.recordID.recordName)
            }
            
        }
    }
    
    static func saveDataToCloud(diaryRecord: Diary, with image: UIImage, clouser: @escaping (String) -> ()) {
        
        let (image, url) = prepareImageToSaveToCloud(record: diaryRecord, image: image)
        
        guard let imageAsset = image, let imageURL = url else { return }
        
        let record = CKRecord(recordType: "Diary")
        record.setValue(diaryRecord.recordName, forKey: "name")
        record.setValue(diaryRecord.recordText, forKey: "text")
        record.setValue(diaryRecord.recordTime, forKey: "time")
        record.setValue(diaryRecord.hasImage ? 1 : 0, forKey: "hasImage")
        record.setValue(imageAsset, forKey: "imageData")
        
        privateCloudDatabase.save(record) { (newRecord, error) in
            if let error = error { print(error); return }
            if let newRecord = newRecord {
                clouser(newRecord.recordID.recordName)
            }
            deleteTempImage(imageURL: imageURL)
        }
    }
    
    static func fetchDataFromCloud(diaryRecords: [Diary], closure: @escaping (DiaryModel) -> ()) {
           
           let query = CKQuery(recordType: "Diary", predicate: NSPredicate(value: true))
           query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
           
           privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
               
               guard error == nil else { print(error!); return }
               guard let records = records else { return }
               
               records.forEach({ (record) in
                   let newDiaryRecord = DiaryModel(record: record)
                   
                   DispatchQueue.main.async {
                    if self.newCloudRecordIsAvailable(diaryRecords: diaryRecords, recordID: newDiaryRecord.id) {
                           closure(newDiaryRecord)
                       }
                   }
               })
           }
       }
    
    static func updateCloudData(diaryRecord: Diary, with image: UIImage) {
        
        let recordID = CKRecord.ID(recordName: diaryRecord.id!)
        
        let (image, url) = prepareImageToSaveToCloud(record: diaryRecord, image: image)
        guard let imageAsset = image, let imageURL = url else { return }
        
        privateCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            
            if let record = record, error == nil {
                
                DispatchQueue.main.async {
                    record.setValue(diaryRecord.recordName, forKey: "name")
                    record.setValue(diaryRecord.recordText, forKey: "text")
                    record.setValue(diaryRecord.hasImage ? 1 : 0, forKey: "hasImage")
                    record.setValue(diaryRecord.recordTime, forKey: "time")
                    record.setValue(imageAsset, forKey: "imageData")
                    
                    privateCloudDatabase.save(record, completionHandler: { (_, error) in
                        if let error = error { print(error.localizedDescription); return }
                        deleteTempImage(imageURL: imageURL)
                    })
                }
            }
        }
    }
    
    static func fetchDataFromCloud(toDoTasks: [ToDoTask], closure: @escaping (ToDoTaskModel) -> ()) {
        
        let query = CKQuery(recordType: "ToDoTask", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
            guard error == nil else { print(error!); return }
            guard let records = records else { return }
            
            records.forEach({ (record) in
                ///
               
                
                let doneBool = record.value(forKey: "done") as! Int
                
                let done = doneBool == 1 ? true : false
                let name = record.value(forKey: "name") as! String
                let parantID = record.value(forKey: "toDoListID") as! String
                let id = record.recordID.recordName
                
                let newTask = ToDoTaskModel(name: name, id: id, parantID: parantID, done: done)
                
                DispatchQueue.main.async {
                    if self.newCloudRecordIsAvailable(toDoTasks: toDoTasks, toDoTaskID: newTask.id) {
                        closure(newTask)
                    }
                }
            })
        }
    }
    
    static func fetchDataFromCloud(toDoLists: [ToDoList], closure: @escaping (ToDoListModel) -> ()) {
        
        let query = CKQuery(recordType: "ToDoList", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
            guard error == nil else { print(error!); return }
            guard let records = records else { return }
            records.forEach({ (record) in
                
                //(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                
                ///////
                let name = record.value(forKey: "name") as! String
                let id = record.recordID.recordName
                let dateOfLastUpdate = record.value(forKey: "dateOfLastUpdate") as! Date
                let newToDoList = ToDoListModel(name: name, id: id, dateOfLastUpdate: dateOfLastUpdate)
                DispatchQueue.main.async {
                    if self.newCloudRecordIsAvailable(toDoLists: toDoLists, toDoListID: newToDoList.id) {
                        print("done")
                        closure(newToDoList)
                    }
                }
            })
        }
    }
    
    static func fetchDataFromCloud(tasks: [Task], closure: @escaping (TaskModel) -> ()) {
        let query = CKQuery(recordType: "Task", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
            guard error == nil else { print(error!); return }
            guard let records = records else { return }
            records.forEach({ (record) in
                
                //(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                
                ///////
                
                let newTask = TaskModel(record: record)
                DispatchQueue.main.async {
                    if self.newCloudRecordIsAvailable(tasks: tasks, taskID: newTask.id) {
                        print("done")
                        closure(newTask)
                    }
                }
            })
        }
    }
    
    static func fetchDataFromCloud(finances: [Finance], closure: @escaping (FinanceModel) -> ()) {
        let query = CKQuery(recordType: "Finance", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
            guard error == nil else { print(error!); return }
            guard let records = records else { return }
            records.forEach({ (record) in
                
                //(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                
                ///////
                
                let newFinance = FinanceModel(record: record)
                DispatchQueue.main.async {
                    if self.newCloudRecordIsAvailable(finances: finances, financeID: newFinance.id) {
                        
                        closure(newFinance)
                    }
                }
            })
        }
    }
    
    private static func newCloudRecordIsAvailable(finances: [Finance], financeID: String) -> Bool {
        for finance in finances {
            if finance.id == financeID {
                return false
            }
        }
        return true
    }
    
    private static func newCloudRecordIsAvailable(tasks: [Task], taskID: String) -> Bool {
        
        for task in tasks {
            if task.id == taskID {
                return false
            }
        }
        
        return true
    }
    
    private static func newCloudRecordIsAvailable(toDoTasks: [ToDoTask], toDoTaskID: String) -> Bool {
        
        for toDoTask in toDoTasks {
            if toDoTask.id == toDoTaskID {
                return false
            }
        }
        
        return true
    }
    
    private static func newCloudRecordIsAvailable(diaryRecords: [Diary], recordID: String) -> Bool {
        
        for record in diaryRecords {
            if record.id == recordID {
                return false
            }
        }
        
        return true
    }
    
    private static func newCloudRecordIsAvailable(toDoLists: [ToDoList], toDoListID: String) -> Bool {
        
        for toDoList in toDoLists {
            if toDoList.id == toDoListID {
                return false
            }
        }
        return true
    }
    
    static func updateCloudData(toDoTask: ToDoTask) {
        let recordID = CKRecord.ID(recordName: toDoTask.id!)
        
        privateCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            
            if let record = record, error == nil {
                
                DispatchQueue.main.async {
                    record.setValue(toDoTask.done ? 1 : 0, forKey: "done")
                    
                    
                    privateCloudDatabase.save(record, completionHandler: { (_, error) in
                        if let error = error { print(error.localizedDescription); return }
                    })
                }
            }
        }
    }
    
    static func updateCloudData(task: Task) {
        
        let recordID = CKRecord.ID(recordName: task.id!)
        
        privateCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            if let record = record, error == nil {
                
                DispatchQueue.main.async {
                    record.setValue(task.name, forKey: "name")
                    record.setValue(task.notes, forKey: "notes")
                    record.setValue(task.notification ? 1 : 0, forKey: "notification")
                    record.setValue(task.notificationIdentifier, forKey: "notificationIdentifier")
                    record.setValue(task.repeatFrequency, forKey: "repeatFrequency")
                    record.setValue(task.timeOfEnd, forKey: "timeOfEnd")
                    record.setValue(task.timeOfStart, forKey: "timeOfStart")
                    record.setValue(task.url, forKey: "url")
                    
                    privateCloudDatabase.save(record) { (_, error) in
                        if let error = error {
                            print(error.localizedDescription); return
                        }
                    }
                }
            }
        }
    }
    
    static func deleteRecord(recordID: String, type: ModelClass) {
        var recordType = ""
        switch type {
        case .toDoList:
            recordType = "ToDoList"
        case .toDoTask:
            recordType = "ToDoTask"
        case .task:
            recordType = "Task"
        case .finance:
            recordType = "Finance"
        case .diary:
            recordType = "Diary"
        }
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["recordID"]
        queryOperation.queuePriority = .veryHigh
        
        queryOperation.recordFetchedBlock = { record in
            if record.recordID.recordName == recordID {
                privateCloudDatabase.delete(withRecordID: record.recordID) { (_, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
            }
        }
        queryOperation.queryCompletionBlock = { (_, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        privateCloudDatabase.add(queryOperation)
    }
    
    // MARK: Private Methods
    private static func prepareImageToSaveToCloud(record: Diary, image: UIImage) -> (CKAsset?, URL?) {
        
        let scale = image.size.width > 1080 ? 1080 / image.size.width : 1
        let scaleImage = UIImage(data: image.pngData()!, scale: scale)
        let imageFilePath = NSTemporaryDirectory() + record.recordName!
        let imageURL = URL(fileURLWithPath: imageFilePath)
        
        guard let dataToPath = scaleImage?.jpegData(compressionQuality: 1) else { return (nil, nil)}
        
        do {
            try dataToPath.write(to: imageURL, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
        
        let imageAsset = CKAsset(fileURL: imageURL)
        
        return (imageAsset, imageURL)
    }
    
    static private func deleteTempImage(imageURL: URL) {
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch {
            print(error.localizedDescription)
        }
    }
}
