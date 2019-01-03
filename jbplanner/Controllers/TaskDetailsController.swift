//
//  ViewController.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 20/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import UIKit

class TaskDetailsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // текущая задача для редактирования
    var task: Task!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskDetail", for: indexPath)
        cell.textLabel?.text = task.name
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }


}

