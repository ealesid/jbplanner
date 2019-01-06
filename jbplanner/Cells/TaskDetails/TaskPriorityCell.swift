//
//  TaskPriorityCell.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 03/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import UIKit

class TaskPriorityCell: UITableViewCell {

    @IBOutlet weak var labelTaskPriority: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
