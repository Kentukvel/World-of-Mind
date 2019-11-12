//
//  AddTaskViewController.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/12/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UITableViewController, UITextViewDelegate {

    
    //MARK: - Variables
    private var taskManager = TaskManager()
    private var operationsWithDate = DateOper()
    var updateTableView: ((Task?) ->())?
    var taskToUpdate: Task?
    var selectedRepeat: Repeat = .never
    
    
    //MARK: - Functions
    private func updateConstraints() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func createNewTask() -> Task {
        let newTask = Task(context: taskManager.context)
        
        return newTask
    }
    
    
    //MARK: - Outlets
    @IBOutlet weak var taskTitle: UITextField!
    
    @IBOutlet weak var timeOfStart: UILabel!
    @IBOutlet weak var timeOfStartDatePicker: UIDatePicker!
    @IBOutlet weak var timeOfStartHeight: NSLayoutConstraint!
    
    @IBOutlet weak var timeOfEnd: UILabel!
    @IBOutlet weak var timeOfEndDatePicker: UIDatePicker!
    @IBOutlet weak var timeOfEndHeight: NSLayoutConstraint!
    
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var remindSwitch: UISwitch!

    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var notes: UITextView!
    
  
    //MARK: - Actions
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        if taskToUpdate != nil {
            
        } else {
            
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notes.delegate = self
        
        
        if taskToUpdate != nil {
        
            

        } else {
            
            //Add hour to timeOfEndDatePicker
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .hour, value: 1, to: Date())
            operationsWithDate.setDatePickerDate(datePicker: timeOfEndDatePicker, date: date!)
            
            
            timeOfStart.text = operationsWithDate.formatDateToString(date: timeOfStartDatePicker.date)
            timeOfEnd.text = operationsWithDate.formatDateToString(date: timeOfEndDatePicker.date)

            
            notes.text = "Notes"
            notes.textColor = UIColor.lightGray
            
            repeatLabel.text = getString(fromRepeat: selectedRepeat)
            
        }
        
        timeOfStartDatePicker.isHidden = true
        timeOfEndDatePicker.isHidden = true
        timeOfStartHeight.constant = 0
        timeOfEndHeight.constant = 0
        updateConstraints()
        
        tableView.estimatedRowHeight = 50
        
    }

    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                timeOfStartDatePicker.isHidden = !timeOfStartDatePicker.isHidden
                if timeOfStartDatePicker.isHidden {
                    timeOfStartHeight.constant = 0
                } else {
                    timeOfStartHeight.constant = 150
                }
                updateConstraints()
            }
            if indexPath.row == 1 {
                timeOfEndDatePicker.isHidden = !timeOfEndDatePicker.isHidden
                if timeOfEndDatePicker.isHidden {
                    timeOfEndHeight.constant = 0
                } else {
                    timeOfEndHeight.constant = 150
                }
                updateConstraints()
            }
        }
    }

    //MARK: - TextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notes.textColor == UIColor.lightGray {
            notes.text = nil
            notes.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if notes.text.isEmpty {
            notes.text = "Notes"
            notes.textColor = UIColor.lightGray
        }
    }
    
    //MARK: - Operations with repeat
    
    func getString(fromRepeat: Repeat) -> String {
        
        switch fromRepeat {
        case .never:
            return "Never"
        case .everyDay:
            return "Every day"
        case .everyWeek:
            return "Every week"
        case .everyMonth:
            return "Every month"
        case .everyYear:
            return "Every year"
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseRepeatSegue" {
            if let destination = segue.destination as? RepeatTableViewController {
                destination.repeatDidSelect = {[weak self] selectedRepeat in
                    self?.selectedRepeat = selectedRepeat
                    self?.repeatLabel.text = self!.getString(fromRepeat: selectedRepeat)
                }
            }
        }
    }
}
