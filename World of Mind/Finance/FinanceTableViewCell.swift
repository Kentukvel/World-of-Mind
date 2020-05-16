//
//  FinanceTableViewCell.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 4/13/20.
//  Copyright © 2020 Левкутник Дмитрий. All rights reserved.
//

import UIKit

class FinanceTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5
        titleLabel.textColor = .white
        costLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
