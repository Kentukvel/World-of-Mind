//
//  TaskTableViewCell.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/22/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeOfEnd: UILabel!
    @IBOutlet weak var taskText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5
        //bgView.layer.opacity = 0.1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
