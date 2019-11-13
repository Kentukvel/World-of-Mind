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
    private var addTaskViewModel: AddTaskViewModel?
    private var taskManager = TaskManager()
    private var operationsWithDate = DateOperations()
    private var notificationManager = NotificationManager()
    private var oldNotificationIdentifier: String?
    var updateTableView: ((Task?) ->())?
    var taskToUpdate: Task?
    var selectedRepeat: Repeat! {
        willSet (newValue) {
            repeatLabel.text = Repeat.getString(fromRepeat: newValue)
        }
    }
    
    let dateFormat = "hh:mm dd-MM-YYYY"
    
    //MARK: - Functions
    private func updateConstraints() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    private func presentAlertController(withText text: String) {
        let ac = UIAlertController(title: "Can't save data", message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        ac.addAction(ok)
        self.present(ac, animated: true)
    }
    
    @objc func timeOfEndDatePickerChanged(picker: UIDatePicker) {
        timeOfEnd.text = operationsWithDate.formatDateToString(date: timeOfEndDatePicker.date, format: nil)
    }
    
    @objc func timeOfStartDatePickerChanged(picker: UIDatePicker) {
        timeOfStart.text = operationsWithDate.formatDateToString(date: picker.date, format: nil)
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
        
        //Check conditions
        guard taskTitle.text != "" else {
            presentAlertController(withText: "Please, enter title of task")
            return
        }
        guard timeOfStartDatePicker.date < timeOfEndDatePicker.date else {
            presentAlertController(withText: "Time of end must be later than time of start")
            return
        }
        
        
        if taskToUpdate != nil {
            //Delete notification with old identifier
            notificationManager.removeNotidication(withIdentifiers: [oldNotificationIdentifier!])
            addTaskViewModel!.saveTask(withRepeat: selectedRepeat)
            updateTableView!(nil)
            
        } else {
            let newTask = addTaskViewModel!.createNewTask(withRepeat: selectedRepeat)
            updateTableView!(newTask)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notes.delegate = self
        
        timeOfStartDatePicker.addTarget(self, action: #selector(timeOfStartDatePickerChanged(picker:)), for: .valueChanged)
        timeOfEndDatePicker.addTarget(self, action: #selector(timeOfEndDatePickerChanged(picker:)), for: .valueChanged)
        
        addTaskViewModel = AddTaskViewModel(taskTitle: taskTitle,
                                            timeOfStartDatePicker: timeOfStartDatePicker,
                                            timeOfEndDatePicker: timeOfEndDatePicker,
                                            remindSwitch: remindSwitch,
                                            url: url,
                                            notes: notes,
                                            selectedTask: taskToUpdate,
                                            timeOfStartLabel: timeOfStart,
                                            timeOfEndLabel: timeOfEnd)
        
        if taskToUpdate != nil {
            
            addTaskViewModel?.setFieldsByTask()
            selectedRepeat = addTaskViewModel?.getRepeat()
            oldNotificationIdentifier = addTaskViewModel?.createIdentifier()
            
        } else {
            
            //Add hour to timeOfEndDatePicker
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .hour, value: 1, to: Date())
            operationsWithDate.setDatePickerDate(datePicker: timeOfEndDatePicker, date: date!)
            
            
            timeOfStart.text = operationsWithDate.formatDateToString(date: timeOfStartDatePicker.date, format: nil)
            timeOfEnd.text = operationsWithDate.formatDateToString(date: timeOfEndDatePicker.date, format: nil)

            
            notes.text = "Notes"
            notes.textColor = UIColor.lightGray
            
            selectedRepeat = .never
            
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
        tableView.deselectRow(at: indexPath, animated: true)
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
    
  
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseRepeatSegue" {
            if let destination = segue.destination as? RepeatTableViewController {
                destination.repeatDidSelect = {[weak self] selectedRepeat in
                    self?.selectedRepeat = selectedRepeat
                    
                }
            }
        }
    }
}
