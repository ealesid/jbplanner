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
    
    let dateFormatter = DateFormatter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
    }
    
    // MARK: tableView

    // 5 секций для отображения данных задачи
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    //  по одной строке в каждой секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 { // additional info section
            return 120
        } else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskName", for: indexPath) as? TaskNameCell else {
                fatalError("Cell Type Error")
            }
            cell.textTaskName.text = task.name
            return cell
            
        case 1: // category
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskCategory", for: indexPath) as? TaskCategoryCell else {
                fatalError("Cell Type Error")
            }
            
            var value: String
            
            if let name = task.category?.name {
                value = name
            } else {
                value = "Not slelected"
            }
            
            cell.labelTaskCategory.text = value
            return cell
            
        case 2: // priority
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskPriority", for: indexPath) as? TaskPriorityCell else {
                fatalError("Cell Type Error")
            }
            
            var value: String
            
            if let name = task.priority?.name {
                value = name
            } else {
                value = "Not slelected"
            }
            
            cell.labelTaskPriority.text = value
            return cell

        case 3: // deadline
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskDeadline", for: indexPath) as? TaskDeadlineCell else {
                fatalError("Cell Type Error")
            }
            
            var value: String
            
            if let deadline = task.deadline {
                value = dateFormatter.string(from: deadline)
            } else {
                value = "No deadline."
            }
            
            cell.labelTaskDeadline.text = value
            return cell

        case 4: // additional info
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskInfo", for: indexPath) as? TaskInfoCell else {
                fatalError("Cell Type Error")
            }
            
            cell.textviewTaskInfo.text = task.info
            return cell

        default:
            fatalError("Cell Type Error")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskDetail", for: indexPath)
        cell.textLabel?.text = task.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Name"
        case 1:
            return "Category"
        case 2:
            return "Priority"
        case 3:
            return "Deadline"
        case 4:
            return "Additional Info"
            
        default:
            return ""
            
        }
    }
}

