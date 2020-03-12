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
        
        gradientLayer = CAGradientLayer()
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    
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
    //Set gradient
    var gradientLayer: CAGradientLayer! {
        didSet {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.colors = [#colorLiteral(red: 0.05882352941, green: 0.1254901961, blue: 0.1529411765, alpha: 1).cgColor, #colorLiteral(red: 0.1254901961, green: 0.2274509804, blue: 0.262745098, alpha: 1).cgColor, #colorLiteral(red: 0.1725490196, green: 0.3254901961, blue: 0.3921568627, alpha: 1).cgColor]
            gradientLayer.locations = [0, 0.5, 1]
        }
    }
  
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
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
//        if segue.identifier == "addTaskSegue" {
//            if let destination = segue.destination as? TasksListViewController {
//                
//            }
//        }
        
    }
    
}
