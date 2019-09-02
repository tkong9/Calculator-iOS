//
//  HistoryCell.swift
//  Beautiful Calculator
//
//  Created by TAEWON KONG on 8/31/19.
//  Copyright © 2019 TAEWON KONG. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var calculation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCalculation(_ equation: String) {
        calculation.text = equation
    }

}
