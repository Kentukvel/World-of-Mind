//
//  TaskListTableViewCell.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 4/13/20.
//  Copyright © 2020 Левкутник Дмитрий. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var listLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
