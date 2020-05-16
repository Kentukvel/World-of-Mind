//
//  ToDoTaskModel.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 5/3/20.
//  Copyright © 2020 Левкутник Дмитрий. All rights reserved.
//

import Foundation

class ToDoTaskModel {
    var name: String
    var id: String
    var parantID: String
    var done: Bool
    
    init(name: String, id: String, parantID: String, done: Bool) {
        self.name = name
        self.id = id
        self.parantID = parantID
        self.done = done
    }
}
