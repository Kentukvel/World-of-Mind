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

    
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var gain: UILabel!
    @IBOutlet weak var loss: UILabel!
    @IBOutlet weak var profit: UILabel!
    @IBOutlet weak var monthBefore: UIButton!
    @IBOutlet weak var monthAfter: UIButton!
    
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

    //Set gradient
    var gradientLayer: CAGradientLayer! {
        didSet {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.colors = [#colorLiteral(red: 0.05882352941, green: 0.1254901961, blue: 0.1529411765, alpha: 1).cgColor, #colorLiteral(red: 0.1254901961, green: 0.2274509804, blue: 0.262745098, alpha: 1).cgColor, #colorLiteral(red: 0.1725490196, green: 0.3254901961, blue: 0.3921568627, alpha: 1).cgColor]
            gradientLayer.locations = [0, 0.5, 1]
        }
    }
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientLayer = CAGradientLayer()
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        self.financeViewModel = FinanceViewModel(gainLabel: gain,
                                                 lossesLabel: loss,
                                                 profitLabel: profit)
        selectedMonth = Date()
        
        
        setColorWhite()
    }
    
    func setColorWhite() {
        month.textColor = .white
        gainLabel.textColor = .white
        lossesLabel.textColor = .white
        profitLabel.textColor = .white
        gain.textColor = .white
        loss.textColor = .white
        profit.textColor = .white
        monthAfter.setTitleColor(.white, for: .normal)
        monthBefore.setTitleColor(.white, for: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfFinance.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceCell", for: indexPath) as! FinanceTableViewCell
        let finance = arrayOfFinance[indexPath.row]
        cell.titleLabel.text = finance.name
        cell.costLabel.text = String(format: "%.2f", finance.cost)
        cell.bgView.backgroundColor = finance.profit ? #colorLiteral(red: 0.5309087634, green: 0.7935131192, blue: 0.3346677423, alpha: 0.5431025257) : #colorLiteral(red: 1, green: 0.2784313725, blue: 0.3254901961, alpha: 0.5)
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CloudManager.deleteRecord(recordID: arrayOfFinance[indexPath.row].id!, type: .finance)
            financeViewModel.context.delete(arrayOfFinance.remove(at: indexPath.row))
            financeViewModel.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.financeViewModel.getResults(finance: self.arrayOfFinance)
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
    
  
    

}
