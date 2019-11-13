//
//  TaskManager.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/12/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit
import CoreData

class TaskManager {

    var arrayOfTasks: [Task]? {
        get {
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            do {
                return try context.fetch(request)
            } catch {
                print(error)
            }
            return []
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func loadTasks(byDate date: Date) -> [Task] {
        var newArray: [Task] = []
        if let arrayOfTasks = self.arrayOfTasks {
            for el in arrayOfTasks {
                
                print(Repeat.getRepeat(fromString: el.repeatFrequency!))
                switch Repeat.getRepeat(fromString: el.repeatFrequency!) {
                case .never:
                    if Calendar.current.dateComponents([.year, .month, .day], from: date) == Calendar.current.dateComponents([.year, .month, .day], from: el.timeOfStart!) {
                        newArray.append(el)
                    }
                case .everyDay:
                    
                    newArray.append(el)
                    
                case .everyWeek:
                    if Calendar.current.dateComponents([.year, .month, .weekday], from: date) == Calendar.current.dateComponents([.year, .month, .weekday], from: el.timeOfStart!) {
                        newArray.append(el)
                    }
                case .everyMonth:
                    if Calendar.current.dateComponents([.year,.day], from: date) == Calendar.current.dateComponents([.year, .day], from: el.timeOfStart!) {
                        newArray.append(el)
                    }
                case .everyYear:
                    if Calendar.current.dateComponents([ .month, .day], from: date) == Calendar.current.dateComponents([.month, .day], from: el.timeOfStart!) {
                        newArray.append(el)
                    }
                }
            }
        }
        return newArray
    }
    
    
}
