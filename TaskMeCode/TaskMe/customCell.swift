//
//  customCell.swift
//  TaskMe
//
//  Created by Pietro Sette on 3/22/17.
//  Copyright © 2017 Pietro Sette. All rights reserved.
//

import UIKit

class customCell: UITableViewCell {
    
    
    @IBOutlet var ammountLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ammountLabel.textColor = UIColor.green
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
