 //
//  SideMenuCell.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 08/04/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // фон для ячейки при нажатии
    @IBInspectable var selectionColor: UIColor = .gray{
        didSet { setBackground() }
    }
    
    
    private func setBackground() {
        let view = UIView()
        view.backgroundColor = selectionColor
        selectedBackgroundView = view
    }

}
