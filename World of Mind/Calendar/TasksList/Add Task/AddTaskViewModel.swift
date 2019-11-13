//
//  AddTaskViewModel.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/13/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit

class AddTaskViewModel {
    
    private var selectedTask: Task?
    private var taskManager = TaskManager()
    private var notificationManager = NotificationManager()
    private var taskTitle: UITextField
    private var timeOfStartDatePicker: UIDatePicker
    private var timeOfEndDatePicker: UIDatePicker
    private var remindSwitch: UISwitch
    private var url: UITextField
    private var notes: UITextView
    private var timeOfStartLabel: UILabel
    private var timeOfEndLabel: UILabel
    
    
    //private let dateFormat = "hh:mm dd-MM-YYYY"
    private var operationWithDate = DateOperations()
    
    init(taskTitle: UITextField,
         timeOfStartDatePicker: UIDatePicker,
         timeOfEndDatePicker: UIDatePicker,
         remindSwitch: UISwitch,
         url: UITextField,
         notes: UITextView,
         selectedTask: Task?,
         timeOfStartLabel: UILabel,
         timeOfEndLabel: UILabel) {
        self.selectedTask = selectedTask
        self.taskTitle = taskTitle
        self.timeOfStartDatePicker = timeOfStartDatePicker
        self.timeOfEndDatePicker = timeOfEndDatePicker
        self.remindSwitch = remindSwitch
        self.url = url
        self.notes = notes
        self.timeOfStartLabel = timeOfStartLabel
        self.timeOfEndLabel = timeOfEndLabel
    }
    
    func createIdentifier() -> String {
        return taskTitle.text! + timeOfStartLabel.text!
    }
    
    func createNewTask(withRepeat: Repeat) -> Task {
        let newTask = Task(context: taskManager.context)
        newTask.name = taskTitle.text
        newTask.timeOfStart = timeOfStartDatePicker.date
        newTask.timeOfEnd = timeOfEndDatePicker.date
        newTask.repeatFrequency = Repeat.getString(fromRepeat: withRepeat)
        newTask.notification = remindSwitch.isOn
        newTask.url = url.text
        newTask.notes = notes.text
        newTask.notificationIdentifier = createIdentifier()
        if newTask.notification {
            notificationManager.scheduleNotificationForTimeTable(with: newTask.name!, at: newTask.timeOfStart!, repeats: withRepeat, identifier: newTask.notificationIdentifier!)
        }
        return newTask
    }
    
    func saveTask(withRepeat selectedRepeat: Repeat) {
        selectedTask?.name = taskTitle.text
        selectedTask?.timeOfStart = timeOfStartDatePicker.date
        selectedTask?.timeOfEnd = timeOfEndDatePicker.date
        selectedTask?.repeatFrequency = Repeat.getString(fromRepeat: selectedRepeat)
        selectedTask?.notification = remindSwitch.isOn
        selectedTask?.url = url.text
        selectedTask?.notes = notes.text
        selectedTask?.notificationIdentifier = createIdentifier()
        if selectedTask!.notification {
            notificationManager.scheduleNotificationForTimeTable(with: selectedTask!.name!, at: selectedTask!.timeOfStart!, repeats: selectedRepeat, identifier: createIdentifier())
        }
        taskManager.save()
        
    }
    
    func setFieldsByTask() {
        if let selectedTask = selectedTask {
            taskTitle.text = selectedTask.name
            timeOfStartDatePicker.date = selectedTask.timeOfStart!
            timeOfEndDatePicker.date = selectedTask.timeOfEnd!
            remindSwitch.isOn = selectedTask.notification
            url.text = selectedTask.url
            notes.text = selectedTask.notes
            timeOfStartLabel.text = operationWithDate.formatDateToString(date: selectedTask.timeOfStart!, format: nil)
            timeOfEndLabel.text = operationWithDate.formatDateToString(date: selectedTask.timeOfEnd!, format: nil)
        }
    }
    
    func getRepeat() -> Repeat {
        return Repeat.getRepeat(fromString: selectedTask!.repeatFrequency!)
    }
}
