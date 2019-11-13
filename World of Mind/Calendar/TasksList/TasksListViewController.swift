//
//  TasksListViewController.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/11/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit
import CoreData

class TasksListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: - Variables
    var selectedDate: Date?
    var dateOperations = DateOperations()
    var taskManager = TaskManager()
    var arrayOfTasks: [Task] = []
    var selectedTask: Task? {
        didSet {
            performSegue(withIdentifier: "editTaskSegue", sender: nil)
        }
    }

    //MARK: - Outlets
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!

    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.title = dateOperations.formatDateToString(date: selectedDate!, format: "dd-MM-YYYY")
        
        arrayOfTasks = taskManager.loadTasks(byDate: selectedDate!)
        
        tableView.reloadData()
       
    }
    
    
    //MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        cell.textLabel?.text = arrayOfTasks[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taskManager.context.delete(arrayOfTasks[indexPath.row])
            arrayOfTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            taskManager.save()
        }
    }

    //MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedTask = arrayOfTasks[indexPath.row]
        
    }
    

    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTaskSegue" {
           
            if let destination = segue.destination as? AddTaskViewController {
                destination.updateTableView = {[weak self] task in
                    self?.arrayOfTasks.append(task!)
                    self?.taskManager.save()
                    self!.tableView.reloadData()
                }
            }
        } else if segue.identifier == "editTaskSegue" {
          
            if let destination = segue.destination as? AddTaskViewController {
                destination.taskToUpdate = selectedTask
                destination.updateTableView = { [weak self] task in
                    self!.tableView.reloadData()
                }
            }
        }
    }

}
