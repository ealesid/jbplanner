//
//  PriorityListCell.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 06/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import UIKit

class PriorityListCell: UITableViewCell {

    @IBOutlet weak var labelPriorityName: UILabel!
    @IBOutlet weak var labelPriorityColor: UILabel!
    @IBOutlet weak var labelTasksCount: UILabel!
    @IBOutlet weak var buttonCheckPriority: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelTasksCount.roundLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
