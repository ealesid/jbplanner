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
    
    // поля задачи (в них будут хранится последние изменные значения, в случае сохранения - эти данные запишутся в task)
    var taskName: String?
    var taskInfo: String?
    var taskPriority: Priority?
    var taskCategory: Category?
    var taskDeadline: Date?
    
    let dateFormatter = DateFormatter()
    
    var delegate: ActionResultDelegate! // нужен для уведомления и вызова функции из контроллера списка задач
    
    // сохраняем ссылки на компоненты
    var textTaskName: UITextField!
    var textViewTaskInfo: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        // сохраняем в соответствующие переменные все данные задачи
        if let task = task {    // если объект не пустой (значит, режим редактирования, а не создания новой задачи)
            taskName = task.name
            taskInfo = task.info
            taskPriority = task.priority
            taskCategory = task.category
            taskDeadline = task.deadline
        }
        
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
            cell.textTaskName.text = taskName
            
            textTaskName = cell.textTaskName // для использования компонента вне метода tableView
            
            return cell
            
        case 1: // category
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskCategory", for: indexPath) as? TaskCategoryCell else {
                fatalError("Cell Type Error")
            }
            
            var value: String
            
            if let name = taskCategory?.name {
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
            
            if let name = taskPriority?.name {
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
            
            if let deadline = taskDeadline {
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
            
            cell.textviewTaskInfo.text = taskInfo
            
            textViewTaskInfo = cell.textviewTaskInfo // для использования компонента вне метода tableView
            
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
    
    // MARK: IBActions
    
    // закрытие контроллера без сохранения
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true) // контроллер удаляется из стека контроллеров
    }
    
    @IBAction func tapSave(_ sender: UIBarButtonItem) {
        
        task.name = textTaskName.text
        task.info = textViewTaskInfo.text
        
        delegate.done(source: self, data: nil)      // можно не передавать обратно task, т.к. reference type
        
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == nil { return }
        
        switch segue.identifier {
        case "selectCategory":
            if let controller = segue.destination as? CategoryListController {
                controller.selectedCategory = taskCategory     // передаем текущее значение категории
            }
            
        case "selectPriority":
            if let controller = segue.destination as? PriorityListController {
                controller.selectedPriority = taskPriority     // передаем текущее значение категории
            }
            
        default:
            return
        }
    }
}

