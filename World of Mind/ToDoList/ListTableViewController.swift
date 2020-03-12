//
//  ListTableViewController.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/14/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    var selectedList: ToDoList?
    var arrayOfTasks: [ToDoTask] = []
    var toDoListViewModel = ToDoListViewModel()
    
    
    private func addNewTask() {
        let ac = UIAlertController(title: "Create new task", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Enter title of task"
        }
        
        let enter = UIAlertAction(title: "Enter", style: .default) { [weak ac, self] (_) in
            let text = ac?.textFields![0].text
            let newTask = ToDoTask(context: self.toDoListViewModel.context)
            newTask.name = text
            newTask.done = false
            let tasks = self.selectedList!.toDoList?.mutableCopy() as? NSMutableSet
            tasks?.add(newTask)
            self.selectedList?.toDoList = tasks
            self.arrayOfTasks.append(newTask)
            self.toDoListViewModel.save()
            self.tableView.reloadData()
        }
        ac.addAction(enter)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancel)
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        addNewTask()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 60
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoTaskCell", for: indexPath)
        cell.textLabel?.text = arrayOfTasks[indexPath.row].name
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoListViewModel.context.delete(arrayOfTasks[indexPath.row])
            toDoListViewModel.save()
            arrayOfTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
