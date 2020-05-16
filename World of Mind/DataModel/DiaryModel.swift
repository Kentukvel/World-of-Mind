//
//  DiaryModel.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 5/7/20.
//  Copyright © 2020 Левкутник Дмитрий. All rights reserved.
//

import Foundation
import CloudKit

struct DiaryModel {
   var name: String = ""
    var text: String = ""
    var hasImage: Bool = false
    var time: Date?
    var id: String = ""
    var imageData: Data?
    
    
    
    init(record: CKRecord) {
        self.hasImage = (record.value(forKey: "hasImage") as! Double) == 1 ? true : false
        if self.hasImage {
            guard let possibleImage = record.value(forKey: "imageData") else { return }
            let imageAsset = possibleImage as! CKAsset
            guard let imageData = try? Data(contentsOf: imageAsset.fileURL!) else { return }
            self.imageData = imageData
        }
        self.name = record.value(forKey: "name") as! String
        self.text = record.value(forKey: "text") as! String
        
        self.time = record.value(forKey: "time") as! Date
        
        self.id = record.recordID.recordName
    }
}
