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
    
    var dateOperations = DateOperations()

    var arrayOfTasks: [Task]? {
        get {
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            do {
                var array = try context.fetch(request)
                array.sort(by: {
                    $0.timeOfStart! < $1.timeOfStart!
                })
                return array
            } catch {
                print(error)
            }
            return []
        }
    }
    
    func configureCell(cell: UITableViewCell, task: Task) {
        if let cell = cell as? TaskTableViewCell {
            let currDate = Date()
            cell.taskText.text = task.name
            cell.timeLabel.text = "Start: " + dateOperations.formatDateToString(date: task.timeOfStart!, format: nil)
            cell.timeOfEnd.text = "End: " + dateOperations.formatDateToString(date: task.timeOfEnd!, format: nil)
            cell.bgView.layer.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 0.6022848887)
            if task.timeOfEnd! > currDate && task.timeOfStart! < currDate{
                cell.bgView.layer.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 0.602151113)
                cell.timeLabel.text = "Current"
            }
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
                
                switch Repeat.getRepeat(fromString: el.repeatFrequency!) {
                case .never:
                    if Calendar.current.dateComponents([.year, .month, .day], from: date) == Calendar.current.dateComponents([.year, .month, .day], from: el.timeOfStart!) {
                        newArray.append(el)
                    }
                case .everyDay:
                    
                    newArray.append(el)
                    
                case .everyWeek:
                    if Calendar.current.dateComponents([.weekday], from: date) == Calendar.current.dateComponents([.year, .month, .weekday], from: el.timeOfStart!) {
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
