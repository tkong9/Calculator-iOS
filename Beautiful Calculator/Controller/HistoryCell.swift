//
//  HistoryCell.swift
//  Beautiful Calculator
//
//  Created by TAEWON KONG on 8/31/19.
//  Copyright © 2019 TAEWON KONG. All rights reserved.
//

import UIKit
import SwipeCellKit

class HistoryCell: SwipeTableViewCell {
    
    @IBOutlet weak var calculationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
