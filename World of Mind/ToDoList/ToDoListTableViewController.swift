//
//  ToDoListTableViewController.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/13/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {

    //MARK: - Variables
    
    private var toDoListViewModel = ToDoListViewModel()
    private var arrayOfLists: [ToDoList]!
    private var selectedList: ToDoList? {
        didSet {
            performSegue(withIdentifier: "toListSegue", sender: self)
        }
    }
    
    //MARK: - Functions
    
    private func addNewList() {
        let ac = UIAlertController(title: "Create new to-do list", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Enter title of to-do list"
        }
        
        let enter = UIAlertAction(title: "Enter", style: .default) { [weak ac, self] (_) in
            let text = ac?.textFields![0].text
            let newList = ToDoList(context: self.toDoListViewModel.context)
            newList.name = text
            newList.dateOfLastUpdate = Date()
            self.arrayOfLists.append(newList)
            self.toDoListViewModel.save()
            self.tableView.reloadData()
        }
        ac.addAction(enter)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancel)
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func addList(_ sender: UIBarButtonItem) {
        addNewList()
    }
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfLists = toDoListViewModel.arrayOfLists
        tableView.estimatedRowHeight = 60
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        cell.textLabel?.text = arrayOfLists[indexPath.row].name
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedList = arrayOfLists[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoListViewModel.context.delete(arrayOfLists[indexPath.row])
            toDoListViewModel.save()
            arrayOfLists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toListSegue" {
            if let destination = segue.destination as? ListTableViewController {
                let tasks = selectedList?.toDoList
                var newArray: [ToDoTask] = []
                for el in tasks! {
                    newArray.append(el as! ToDoTask)
                }
                destination.arrayOfTasks = newArray
                destination.selectedList = selectedList
            }
        }
    }

}
