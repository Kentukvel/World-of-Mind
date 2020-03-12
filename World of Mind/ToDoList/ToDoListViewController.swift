//
//  ToDoListTableViewController.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/13/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Variables
    
    private var toDoListViewModel = ToDoListViewModel()
    private var arrayOfLists: [Any]!
    private var selectedTasks: Set<Int> = []
    
    @IBOutlet weak var createList: UIButton!
    @IBOutlet weak var tableView: UITableView!
    //    private var selectedList: ToDoList? {
//        didSet {
//           // performSegue(withIdentifier: "toListSegue", sender: self)
//        }
//    }
    @IBAction func createList(_ sender: UIButton) {
        if createList.titleLabel?.text == "Create list" {
            addNewList()
        }
    }
    
    //Gradient
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
    
 
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfLists = toDoListViewModel.arrayOfLists()
        tableView.estimatedRowHeight = 60
        
        tableView.register(UINib(nibName: "AddTableViewCell", bundle: nil), forCellReuseIdentifier: "AddNewToDoCell")
        tableView.register(UINib(nibName: "TaskToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskToDoCell")
        
        gradientLayer = CAGradientLayer()
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        tableView.keyboardDismissMode = .onDrag
    }
    
    

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let choosenElement = (arrayOfLists[indexPath.row] as AnyObject) as? ToDoList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
            cell.textLabel?.text = choosenElement.name
            return cell
        } else if arrayOfLists[indexPath.row] as? String == "emptyTask" {
            //print("done")
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewToDoCell", for: indexPath) as! AddTableViewCell
            cell.getNewTask = {[weak self] (name) in
                let getList: ToDoList? = {
                    for i in (0..<indexPath.row).reversed() {
                        if let list = (self?.arrayOfLists[i] as AnyObject) as? ToDoList {
                            return list
                        }
                    }
                    return nil
                }()
                guard getList != nil else {
                    return
                }
                self?.toDoListViewModel.addTask(withText: name, forList: getList!, indexPath: indexPath, oldArray: &self!.arrayOfLists)
                
                self?.resignFirstResponder()
//                self?.updateViewwithDeleteCell(atIndexPath: indexPath)
                self!.tableView.reloadData()
                cell.addText.text = ""
                cell.editingTextIsActive = false
            }
            cell.callBack = {
                
                textView in
                // update data source
                // tell table view we're starting layout updates
                tableView.beginUpdates()
                // get current content offset
                var scOffset = tableView.contentOffset
                // get current text view height
                let tvHeight = textView.frame.size.height
                // telll text view to size itself
                textView.sizeToFit()
                // get the difference between previous height and new height (if word-wrap or newline change)
                let yDiff = textView.frame.size.height - tvHeight
                // adjust content offset
                scOffset.y += yDiff
                // update table content offset so edit caret is not covered by keyboard
                tableView.contentOffset = scOffset
                // tell table view to apply layout updates
                tableView.endUpdates()
               
                
            }
            return cell
        } else if let choosenElement = (arrayOfLists[indexPath.row] as AnyObject) as? ToDoTask {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskToDoCell", for: indexPath) as! TaskToDoTableViewCell
            cell.selectedTask = choosenElement
            cell.checkIsOn = choosenElement.done
            cell.name.text = choosenElement.name
            cell.setImage()
            return cell
        }
        
        return UITableViewCell()
    }
    
    func updateViewwithDeleteCell(atIndexPath indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectedList = arrayOfLists[indexPath.row]
        if let selectedList = arrayOfLists[indexPath.row] as? ToDoList {
            if !selectedTasks.contains(indexPath.row) {
                //selectedTasks.append(indexPath.row)
                selectedTasks.insert(indexPath.row)
                arrayOfLists = toDoListViewModel.updateListWithTasks(taskDidChoosed: selectedList, index: indexPath.row, oldArray: arrayOfLists as! [AnyObject])
            } else {
                selectedTasks.remove(indexPath.row)
                arrayOfLists = toDoListViewModel.hideTasks(taskDidChoosed: selectedList, atIndex: indexPath.row, oldArray: arrayOfLists as! [AnyObject])
            }
            
            tableView.reloadData()
        }
    }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let selectedElement = arrayOfLists[indexPath.row] as? ToDoTask {
            if editingStyle == .delete {
                toDoListViewModel.context.delete(selectedElement)
                toDoListViewModel.save()
                arrayOfLists.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
        } else if let selectedElement = arrayOfLists[indexPath.row] as? ToDoList {
            if editingStyle == .delete {
                if selectedTasks.contains(indexPath.row) { //если список открыт
                    selectedTasks.remove(indexPath.row)
                    arrayOfLists = toDoListViewModel.hideTasks(taskDidChoosed: selectedElement, atIndex: indexPath.row, oldArray: arrayOfLists! as [AnyObject])
                    arrayOfLists.remove(at: indexPath.row)
                    toDoListViewModel.context.delete(selectedElement)
                    toDoListViewModel.save()
                    tableView.reloadData()
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if arrayOfLists[indexPath.row] as? String == "emptyTask" {
            return false
        }
        return true
    }
    
    //MARK: - Navigation
    

}
