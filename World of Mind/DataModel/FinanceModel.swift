//
//  FinanceModel.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 5/4/20.
//  Copyright © 2020 Левкутник Дмитрий. All rights reserved.
//

import Foundation
import CloudKit

class FinanceModel {
    var name: String
    var cost: Double
    var date: Date
    var profit: Bool
    var id: String
    
    init(record: CKRecord) {
        self.name = record.value(forKey: "name") as! String
        self.cost = record.value(forKey: "cost") as! Double
        self.profit = (record.value(forKey: "profit") as! Double) == 1 ? true : false
        self.date = record.value(forKey: "date") as! Date
        self.id = record.recordID.recordName
    }
}
