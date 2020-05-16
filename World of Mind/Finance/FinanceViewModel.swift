//
//  FinanceViewModel.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/14/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit
import CoreData

class FinanceViewModel {
    
    var monthesRecords: [Month]! {
        get {
            let request: NSFetchRequest<Month> = Month.fetchRequest()
            do {
                return try context.fetch(request)
            } catch {
                print(error)
            }
            return []
        }
    }
    
    func createNewRecord(profit: Bool, name: String, cost: Double) -> Finance {
        let newRecord = Finance(context: self.context)
        newRecord.cost = cost
        newRecord.date = Date()
        newRecord.profit = profit
        newRecord.name = name
        
        CloudManager.saveDataToCloud(finance: newRecord) { (id) in
            newRecord.id = id
        }
        
        let selectedMonth = self.selectedMonth(date: newRecord.date!)
        
        let finances = selectedMonth!.finance?.mutableCopy() as? NSMutableSet
        finances?.add(newRecord)
        selectedMonth?.finance = finances
        
        
        save()
        return newRecord
    }
    
    var gainLabel: UILabel!
    var lossesLabel: UILabel!
    var profitLabel: UILabel!
    
    init(gainLabel: UILabel!, lossesLabel: UILabel!, profitLabel: UILabel!) {
        self.gainLabel = gainLabel
        self.lossesLabel = lossesLabel
        self.profitLabel = profitLabel
    }
    
    func getResults(finance: [Finance]) {
        var gain: Double = 0
        var loss: Double = 0
        for el in finance {
            if el.profit {
                gain += el.cost
            } else {
                loss += el.cost
            }
        }
        let profit = gain - loss
        let gainStr = String(format: "%.2f", gain)
        let lossStr = String(format: "%.2f", loss)
        let profitStr = String(format: "%.2f", profit)
        gainLabel.text = gainStr
        lossesLabel.text = lossStr
        profitLabel.text = profitStr
        
    }
    
    func getMonthBefore(date: Date) -> Date {
        let lastMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: date)
        return lastMonthDate!
    }
    
    func getMonthAfter(date: Date) -> Date {
        let lastMonthDate = Calendar.current.date(byAdding: .month, value: +1, to: date)
        return lastMonthDate!
    }
    
    func getFinanceForMonth(date: Date) -> [Finance] {
        
        var selectedMonth = self.selectedMonth(date: date)
        
        if selectedMonth == nil {
            selectedMonth = createNewMonth()
        }
        
        let financeSet = selectedMonth?.finance
        var newArray = [Finance]()
        for el in financeSet! {
            newArray.append(el as! Finance)
        }
        ////!!!!!!!!!!
        CloudManager.fetchDataFromCloud(finances: newArray) { (finance) in
            if Calendar.current.dateComponents([.year, .month], from: finance.date) == Calendar.current.dateComponents([.year, .month], from: selectedMonth!.date!) {
                let newFinance = Finance(context: self.context)
                newFinance.id = finance.id
                newFinance.date = finance.date
                newFinance.name = finance.name
                newFinance.cost = finance.cost
                newFinance.profit = finance.profit
                
                newArray.append(newFinance)
                
                self.save()
            }
        }
        newArray.sort { (first, second) -> Bool in
            first.date! > second.date!
        }
        
        return newArray
    }
        
    
    func selectedMonth(date: Date) -> Month? {
        let calendar = Calendar.current
        let monthFromDate = calendar.dateComponents([.year, .month], from: date)
        
        var selectedMonth: Month? = nil
        
        for el in monthesRecords {
            if calendar.dateComponents([.year, .month], from: el.date!) == monthFromDate {
                selectedMonth = el
                break
            }
        }
        return selectedMonth
    }
    
    
    func createNewMonth() -> Month {
        let newMonth = Month(context: context)
        newMonth.date = Date()
        save()
        return newMonth
    }
    
    //CRUD operations
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }

}

