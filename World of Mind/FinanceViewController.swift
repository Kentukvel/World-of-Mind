//
//  FinanceViewController.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/14/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit

class FinanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrayOfFinance: [Finance] = []
    var financeViewModel: FinanceViewModel!
    var dateOperations = DateOperations()
    
    var selectedMonth: Date! {
        willSet {
            month.text = dateOperations.formatDateToString(date: newValue, format: "MMM YYYY") 
            arrayOfFinance = financeViewModel.getFinanceForMonth(date: newValue)
            financeViewModel.getResults(finance: arrayOfFinance)

            tableView.reloadData()
        }
    }
    
    func enterNewFinance(isGain: Bool) {
        let ac = UIAlertController(title: "Enter title and amount of \(isGain ? "gain" : "loss")", message: nil, preferredStyle: .alert)
        ac.addTextField { (field) in
            field.placeholder = "Enter title"
        }
        ac.addTextField { (field) in
            field.placeholder = "Enter amount"
        }
        
        let ok = UIAlertAction(title: "OK", style: .default) { (_) in
            self.arrayOfFinance.append(self.financeViewModel.createNewRecord(profit: isGain, name: ac.textFields![0].text!, cost: Double(ac.textFields![1].text!)!))
            self.financeViewModel.getResults(finance: self.arrayOfFinance)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(ok)
        ac.addAction(cancel)
        self.present(ac, animated: true)
    }
    
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var gain: UILabel!
    @IBOutlet weak var loss: UILabel!
    @IBOutlet weak var profit: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBAction func addLoss(_ sender: UIButton) {
        enterNewFinance(isGain: false)
        
    }
    @IBAction func addGain(_ sender: UIButton) {
        enterNewFinance(isGain: true)
    }
    
    
    
    
    @IBAction func monthAfter(_ sender: UIButton) {
        selectedMonth = financeViewModel.getMonthAfter(date: selectedMonth)
    }
    @IBAction func monthBefore(_ sender: UIButton) {
        selectedMonth = financeViewModel.getMonthBefore(date: selectedMonth)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.financeViewModel = FinanceViewModel(gainLabel: gain,
                                                 lossesLabel: loss,
                                                 profitLabel: profit)
                selectedMonth = Date()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfFinance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceCell", for: indexPath)
        cell.textLabel?.text = arrayOfFinance[indexPath.row].name
        cell.detailTextLabel!.text = String(format: "%.2f", arrayOfFinance[indexPath.row].cost)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            financeViewModel.context.delete(arrayOfFinance.remove(at: indexPath.row))
            financeViewModel.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    

}
