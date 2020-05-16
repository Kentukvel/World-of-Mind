//
//  diaryViewModel.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/14/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit
import CoreData

class DiaryViewModel {
    
    var dateOperations = DateOperations()
    
    var diaryRecords: [Diary]? {
        get {
            let request: NSFetchRequest<Diary> = Diary.fetchRequest()
            do {
                return try context.fetch(request)
            } catch {
                print(error)
            }
            return []
        }
    }
    
    func configure(cell: DiaryRecordTableViewCell, withRecord record: Diary) {
        if record.hasImage {
            if record.image != nil {
                cell.imageOfRecord.image = UIImage(data: record.image!)
            }
        } else {
            
            cell.imageWidth.constant = 0
            cell.imageOfRecord.isHidden = true
        }
        
        cell.titleOfRecord.text = record.recordName
        cell.textOfRecord.text = record.recordText
        cell.timeOfRecord.text = dateOperations.formatDateToString(date: record.recordTime!, format: nil)
    }
    
    func saveNewRecord(name: String, text: String, hasImage: Bool, image: Data?) -> Diary {
        let newRecord = Diary(context: self.context)
        newRecord.recordName = name
        newRecord.recordText = text
        newRecord.recordTime = Date()
        newRecord.hasImage = hasImage
        if hasImage {
            newRecord.image = image
        }
        CloudManager.saveDataToCloud(diaryRecord: newRecord, with: UIImage(data: image!)!) { (id) in
            newRecord.id = id
        }
        save()
        return newRecord
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
