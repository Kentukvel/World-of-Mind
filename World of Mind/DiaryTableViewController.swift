//
//  DiaryTableViewController.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/14/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit

class DiaryTableViewController: UITableViewController {
    
    //MARK: - Variables
    var diaryViewModel = DiaryViewModel()
    var diaryRecords = [Diary]()
    
    var selectedRecord: Diary? {
        didSet {
            performSegue(withIdentifier: "selectedRecord", sender: self)
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        diaryRecords = diaryViewModel.diaryRecords!
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
            diaryViewModel.context.delete(diaryRecords[indexPath.row])
            diaryViewModel.save()
            diaryRecords.remove(at: indexPath.row)
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
