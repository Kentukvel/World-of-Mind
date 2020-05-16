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
        
        
        
        gradientLayer = CAGradientLayer()
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        navigationBar.title = dateOperations.formatDateToString(date: selectedDate!, format: "dd-MM-YYYY")
        
        arrayOfTasks = taskManager.loadTasks(byDate: selectedDate!)
        
        tableView.reloadData()
        
        
    }
    
    
    
    //Set gradient
    var gradientLayer: CAGradientLayer! {
        didSet {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.colors = [#colorLiteral(red: 0.05882352941, green: 0.1254901961, blue: 0.1529411765, alpha: 1).cgColor, #colorLiteral(red: 0.1254901961, green: 0.2274509804, blue: 0.262745098, alpha: 1).cgColor, #colorLiteral(red: 0.1725490196, green: 0.3254901961, blue: 0.3921568627, alpha: 1).cgColor]
            gradientLayer.locations = [0, 0.5, 1]
        }
    }
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    //MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        taskManager.configureCell(cell: cell, task: arrayOfTasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CloudManager.deleteRecord(recordID: arrayOfTasks[indexPath.row].id!, type: .task)
            taskManager.context.delete(arrayOfTasks[indexPath.row])
            arrayOfTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            taskManager.save()
        }
    }

    //MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedTask = arrayOfTasks[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTaskSegue" {
           
            if let destination = segue.destination as? AddTaskViewController {
                destination.updateTableView = {[weak self] task in
                    self?.arrayOfTasks.append(task!)
                    
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
