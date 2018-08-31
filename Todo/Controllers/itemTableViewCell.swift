//
//  itemTableViewCell.swift
//  Todo
//
//  Created by Julie Wang on 2018-08-31.
//  Copyright © 2018 Julie Wang. All rights reserved.
//

import UIKit
import SwipeCellKit

class itemTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
