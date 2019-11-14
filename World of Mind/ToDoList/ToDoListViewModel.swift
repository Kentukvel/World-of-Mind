//
//  ToDoListViewModel.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/13/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewModel {
    
    var arrayOfLists: [ToDoList]? {
        get {
            let request: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
            do {
                return try context.fetch(request)
            } catch {
                print(error)
            }
            return []
        }
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
}
