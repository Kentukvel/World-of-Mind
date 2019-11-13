//
//  OperationsWithDate.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/12/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit

class DateOperations {
    
    func formatDateToString(date: Date, format: String?) -> String {
        let dateFormatter = DateFormatter()
        if let format = format {
            dateFormatter.dateFormat = format
        } else {
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            
        }
        
        return dateFormatter.string(from: date)
    }
    
    func setDatePickerDate(datePicker: UIDatePicker, date: Date) {
        
        datePicker.date = date
    }
}
