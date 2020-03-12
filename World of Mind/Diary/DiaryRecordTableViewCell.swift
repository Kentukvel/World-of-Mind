//
//  DiaryRecordTableViewCell.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 12/9/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit

class DiaryRecordTableViewCell: UITableViewCell {


    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageOfRecord: UIImageView!
    @IBOutlet weak var titleOfRecord: UILabel!
    @IBOutlet weak var textOfRecord: UILabel!
    @IBOutlet weak var timeOfRecord: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
