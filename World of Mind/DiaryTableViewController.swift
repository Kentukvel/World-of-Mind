//
//  DiaryTableViewController.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/14/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit
import CoreData

class DiaryTableViewController: UITableViewController {
    
    //MARK: - Variables
    var diaryViewModel = DiaryViewModel()
    var diaryRecords = [Diary]()
    
    var selectedRecord: Diary? {
        didSet {
            performSegue(withIdentifier: "selectedRecord", sender: self)
        }
    }
    
    //Gradient
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
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayer = CAGradientLayer()
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        diaryRecords = diaryViewModel.diaryRecords!
        CloudManager.fetchDataFromCloud(diaryRecords: diaryRecords) { (record) in
            let newRecord = Diary(context: self.diaryViewModel.context)
            newRecord.hasImage = record.hasImage
            newRecord.recordName = record.name
            newRecord.image = record.imageData
            newRecord.id = record.id
            newRecord.recordText = record.text
            newRecord.recordTime = record.time
            self.diaryRecords.append(newRecord)
            self.diaryViewModel.save()
            self.tableView.reloadData()
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return diaryRecords.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryRecordCell", for: indexPath) as! DiaryRecordTableViewCell

        //cell.textLabel?.text = diaryRecords[indexPath.row].recordName
        diaryViewModel.configure(cell: cell, withRecord: diaryRecords[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedID = diaryRecords[indexPath.row].id
            diaryViewModel.context.delete(diaryRecords[indexPath.row])
            diaryViewModel.save()
            diaryRecords.remove(at: indexPath.row)
            CloudManager.deleteRecord(recordID: deletedID!, type: .diary)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecord = diaryRecords[indexPath.row]
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedRecord" {
            if let destination = segue.destination as? NewRecordViewController {
                destination.selectedRecord = selectedRecord
                destination.updateTable = {(_) in
                    self.tableView.reloadData()
                }
            }
        } else if segue.identifier == "newRecordSegue" {
            if let destination = segue.destination as? NewRecordViewController {
                destination.updateTable = {(record) in
                    
                    //self.diaryRecords.append(record!)
                    self.diaryRecords.insert(record!, at: 0)
                    self.tableView.reloadData()
                }
            }
        }
    }
    


}
