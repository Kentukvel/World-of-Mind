//
//  ToDoList.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 5/3/20.
//  Copyright © 2020 Левкутник Дмитрий. All rights reserved.
//

import Foundation

class ToDoListModel {
    var name: String
    var id: String
    var dateOfLastUpdate: Date
    
    init(name: String, id: String, dateOfLastUpdate: Date) {
        self.name = name
        self.id = id
        self.dateOfLastUpdate = dateOfLastUpdate
    }
}
