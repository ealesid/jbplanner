//
//  TableNameCell.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 03/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import UIKit

class TaskNameCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textTaskName: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textTaskName.delegate = self // обработку событий для текстового поля будет выполнять текущий класс
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textTaskName.resignFirstResponder() // снять фокус с текстового поля (клавиатура исчезнет)
        return true
    }

}
