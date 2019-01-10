//
//  QuickTaskCell.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 10/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import UIKit

class QuickTaskCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textQuickTask: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textQuickTask.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textQuickTask.resignFirstResponder() // снять фокус с текстового поля (клавиатура исчезнет)
        return true
    }


}
