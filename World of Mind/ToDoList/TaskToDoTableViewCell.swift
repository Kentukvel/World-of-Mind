//
//  TaskTableViewCell.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 12/5/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit

class TaskToDoTableViewCell: UITableViewCell {

    var toDoListViewModel = ToDoListViewModel()
    var selectedTask: ToDoTask?
    var checkIsOn: Bool = false
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var check: UIButton!
    
    func setImage() {
        check.setImage(UIImage(named: checkIsOn ? "002-verified" : "001-circle-outline"), for: .normal)
    }
    
    @IBAction func check(_ sender: UIButton) {
        checkIsOn = !checkIsOn
        toDoListViewModel.setCheck(forTask: selectedTask!)
        setImage()
        print(selectedTask?.done)
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
