//
//  RepeatTableViewController.swift
//  World of Mind
//
//  Created by Левкутник Дмитрий on 11/12/19.
//  Copyright © 2019 Левкутник Дмитрий. All rights reserved.
//

import UIKit

class RepeatTableViewController: UITableViewController {

    var repeatDidSelect: ((Repeat) -> ())?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        repeatDidSelect!(Repeat(rawValue: indexPath.row)!)
        //print(Repeat(rawValue: indexPath.row)!)
        navigationController?.popViewController(animated: true)
    }
    
}
