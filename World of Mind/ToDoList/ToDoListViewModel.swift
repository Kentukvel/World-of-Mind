//
//  ToDoListViewModel.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/13/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit
import CoreData

protocol AddTask {
    func addTask(withText text: String, forList list: ToDoList, indexPath: IndexPath, oldArray: inout [Any])
}
class ToDoListViewModel: AddTask {
    
    func arrayOfLists() -> [ToDoList]? {
        
        let request: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print(error)
        }
        return []
        
    }
    
    
    func updateListWithTasks(taskDidChoosed: ToDoList, index: Int, oldArray: [AnyObject]) -> [AnyObject] {
        var newArray = oldArray
        let addTasks = taskDidChoosed.toDoList?.allObjects as! [ToDoTask]
        newArray.insert(contentsOf: addTasks, at: index + 1)
        newArray.insert("emptyTask" as AnyObject, at: index + 1 + addTasks.count)
        return newArray
    }
    
    func getTasksByList(list: ToDoList) -> Set<ToDoTask>? {
        return list.toDoList as? Set<ToDoTask>
    }
    
    func hideTasks(taskDidChoosed: ToDoList, atIndex: Int, oldArray: [AnyObject]) -> [AnyObject] {
        var newArray = oldArray
        
        
        guard let tasksToRemove = taskDidChoosed.toDoList else {
                newArray.remove(at: atIndex + 1)
                return newArray
        }
        //            for i in (0..<tasksToRemove.count).reversed() {
        //                for j in (0..<newArray.count).reversed() {
//                    if newArray[j] as! NSObject == tasksToRemove[i] {
//                        newArray.remove(at: j)
//                        break
//                    }
//                }
//            }
//        }
                //Тут может быть баг с удалением не того элемента
        var i = -1
        for el in newArray {
            i += 1
            if (tasksToRemove.contains(el)) {
                print(i)
                newArray.remove(at: i)
                i -= 1
            }

        }
        newArray.remove(at: atIndex + 1)
        return newArray
    }
    
    
    //CRUD operations
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    
    
    func addTask(withText text: String, forList list: ToDoList, indexPath: IndexPath, oldArray: inout [Any]) {
        let newTask = ToDoTask(context: self.context)
        newTask.name = text
        newTask.done = false
        newTask.parantID = list.id
        let tasks = list.toDoList?.mutableCopy() as? NSMutableSet
        tasks?.add(newTask)
        list.toDoList = tasks
        
        oldArray.remove(at: indexPath.row)
        oldArray.insert(newTask, at: indexPath.row)
        oldArray.insert("emptyTask", at: indexPath.row + 1)
        
        CloudManager.saveDataToCloud(toDoTask: newTask, for: list) { (id) in
            newTask.id = id
        }
        self.save()
    }
    
    //Function for taskToDoTableViewCell
    func setCheck(forTask task: ToDoTask) {
        task.done = !task.done
        CloudManager.updateCloudData(toDoTask: task)
        save()
    }
}
