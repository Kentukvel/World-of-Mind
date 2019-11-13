//
//  CalendarViewController.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/11/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit

enum MyTheme {
    case light
}

class CalendarViewController: UIViewController, CellTapped {
    
    var selectedDate: Date?
    func cellTapped(date: Date) {
        selectedDate = date
        performSegue(withIdentifier: "openDaySegue", sender: self)
    }
    
    var taskManager = TaskManager()
    

    var theme = MyTheme.light
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //load task array
        
        
        
        
        self.title = "My Calender"
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive = true
        
        calenderView.delegate = self
        
        let rightBarBtn = UIBarButtonItem(title: "Add Task", style: .plain, target: self, action: #selector(rightBarBtnAction))
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
//        if theme == .dark {
//            sender.title = "Dark"
//            theme = .light
//            Style.themeLight()
//        } else {
//            sender.title = "Light"
//            theme = .dark
//            Style.themeDark()
//        }
//        self.view.backgroundColor=Style.bgColor
//        calenderView.changeTheme()

        performSegue(withIdentifier: "addTaskSegue", sender: nil)
    }
    
    let calenderView: CalenderView = {
        let v = CalenderView(theme: MyTheme.light)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openDaySegue" {
            if let destination = segue.destination as? TasksListViewController {
                destination.selectedDate = self.selectedDate
            }
        }
        
    }
    
}
