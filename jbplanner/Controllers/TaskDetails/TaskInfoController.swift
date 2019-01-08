//
//  TaskInfoController.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 08/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import UIKit

class TaskInfoController: UIViewController {

    @IBOutlet weak var textviewTaskInfo: UITextView!
    
    var taskInfo: String!       // текущий выбранный элемент
    
    var delegate: ActionResultDelegate!     // для передачи выбранного элемента обратно в контроллер
    

    override func viewDidLoad() {
        super.viewDidLoad()
        textviewTaskInfo.text = taskInfo
    }
    

    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapSave(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        delegate?.done(source: self, data: textviewTaskInfo.text)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}