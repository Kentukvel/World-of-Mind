//
//  AddTableViewCell.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/26/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit

class AddTableViewCell: UITableViewCell, UITextViewDelegate {

    var getNewTask: ((String) -> ())?
    var callBack: ((UITextView) -> ())?
    var addTaskDelegate: AddTask?
    
    var editingTextIsActive = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addText.delegate = self
        addText.isScrollEnabled = false
        
    }
    @IBAction func addButton(_ sender: UIButton) {
        if editingTextIsActive == false {
            addText.becomeFirstResponder()
            editingTextIsActive = true
        } else {
            print("add new el")
            guard addText.text != "" else {
                addText.becomeFirstResponder()
                return
            }
            getNewTask!(addText.text)
            
        }
    }
    @IBOutlet weak var addText: UITextView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidChange(_ textView: UITextView) {
        callBack?(addText)
    }
    
}
