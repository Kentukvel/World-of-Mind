//
//  AddTaskViewController.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/12/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {

    private var taskManager = TaskManager()
    var updateTableView: ((Task?) ->())?
    var taskToUpdate: Task?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func createNewTask() -> Task {
        let newTask = Task(context: taskManager.context)
        newTask.name = "Hello"
        return newTask
    }
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        if taskToUpdate != nil {
            taskToUpdate?.name = "zaebumba"
            taskManager.saveTask()
            self.updateTableView!(nil)
        } else {
            let newTask = createNewTask()
            taskManager.saveTask()
            self.updateTableView!(newTask)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    


}
