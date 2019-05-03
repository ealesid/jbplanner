//
//  CategoryListCell.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 06/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import UIKit

class CategoryListCell: UITableViewCell {
    
    
    @IBOutlet weak var labelCategoryName: UILabel!
    @IBOutlet weak var labelTasksCount: UILabel!
    @IBOutlet weak var buttonCheckCategory: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelTasksCount.roundLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
