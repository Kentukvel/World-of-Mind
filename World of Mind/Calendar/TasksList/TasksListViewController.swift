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
    
    var taskManager = TaskManager()
    var arrayOfTasks: [Task] = []
    var selectedTask: Task? {
        didSet {
            performSegue(withIdentifier: "editTaskSegue", sender: nil)
        }
    }

    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        taskManager.loadTasks(arrayOfTasks: &arrayOfTasks)
        tableView.reloadData()
        // Do any additional setup after loading the view.
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
        }
    }

    //MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedTask = arrayOfTasks[indexPath.row]
        
    }
    

    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTaskSegue" {
            print("1")
            if let destination = segue.destination as? AddTaskViewController {
                destination.updateTableView = {[weak self] task in
                    self?.arrayOfTasks.append(task!)
                    self!.tableView.reloadData()
                }
            }
        } else if segue.identifier == "editTaskSegue" {
            print("2")
            if let destination = segue.destination as? AddTaskViewController {
                destination.taskToUpdate = selectedTask
                destination.updateTableView = { [weak self] task in
                    self!.tableView.reloadData()
                }
            }
        }
    }

}
