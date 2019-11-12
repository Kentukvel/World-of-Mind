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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveTask() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func loadTasks(arrayOfTasks: inout [Task]) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            try arrayOfTasks = context.fetch(request)
        } catch {
            print(error)
        }
    }
    
}
