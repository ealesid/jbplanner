//
//  TaskListController.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 24/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import CoreData
import UIKit

class TaskListController: UITableViewController, ActionResultDelegate {
    
    let db = Db()
    
    let dateFormatter = DateFormatter()
    
    let taskDAO = TaskDaoDbImpl.current
    let categoryDAO = CategoryDaoDbImpl.current
    let priorityDAO = PriorityDaoDbImpl.current
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
       
        // db.initData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    // методы вызываются автоматически компонентом tableView
    
    // количество секций в таблице
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // количество записей в каждой секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskDAO.items.count
    }

    // отображение данных в строке
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTask", for: indexPath) as? TaskListCell else {
            fatalError("Cell Type Error")
        }
        
        let task = taskDAO.items[indexPath.row]
        
        cell.labelTaskName.text = task.name
        cell.labelTaskCategory.text = (task.category?.name ?? "")
        
        if let priority = task.priority {
            switch priority.index {
            case 1:
                cell.labelPriority.backgroundColor = UIColor(named: "low")
            case 2:
                cell.labelPriority.backgroundColor = UIColor(named: "medium")
            case 3:
                cell.labelPriority.backgroundColor = UIColor(named: "high")
            default:
                cell.labelPriority.backgroundColor = UIColor.white
            }
        } else {
            cell.labelPriority.backgroundColor = UIColor.white
        }
        
        cell.labelDeadLine.textColor = .lightGray
        
        // отображать или нет иконку блокнота
        if task.info == nil || (task.info?.isEmpty)! {
            cell.buttonTaskInfo.isHidden = true
        } else {
            cell.buttonTaskInfo.isHidden = false
        }
        
        if let diff = task.daysLeft() {
            switch diff {
            case 0:
                cell.labelDeadLine.text = "Today" // TODO: localization
            case 1:
                cell.labelDeadLine.text = "Tomorrow"
            case 0...:
                cell.labelDeadLine.text = "\(diff) day(s)"
            case ..<0:
                cell.labelDeadLine.textColor = .red
                cell.labelDeadLine.text = "\(diff) day(s)"
            default:
                cell.labelDeadLine.text = ""
            }
        }

        return cell
    }
    
    // установка высоты строки
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteTask(indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appripriate class, insert it into the array, and add a new row to the tableView
            
        }
    }
    
    
    
    //название для каждой секции
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section " + String(section + 1)
//    }
//
//    // высота каждой секции
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier! {
        case "updateTask":
            
            // приведение sender к типу ячейки (получаем доступ к нажатой ячейке)
            let selectedCell = sender as! TaskListCell
            
            let selectedIndex = (tableView.indexPath(for: selectedCell)?.row)!
            let selectedTask = taskDAO.items[selectedIndex]
            
            // получаем доступ к целевому контроллеру
            guard let controller = segue.destination as? TaskDetailsController else {
                fatalError("Destination Controller select error")
            }
            
            controller.title = "Editing"
            controller.task = selectedTask // передаем задачу в целевой контроллер
            controller.delegate = self
            
        default:
            return
        }
    }
    
    // MARK: ActionResultDelegate
    
    // может обрабатывать ответы (слушать действия) от любых контроллеров
    func done(source: UIViewController, data: Any?) {
        
        // если пришел ответт от TaskDetailsController
        if source is TaskDetailsController {
            if let selectedIndexPaht = tableView.indexPathForSelectedRow { // определяем выбранную строку
                taskDAO.save() // сохраняем измененную задачу (сохраняет все изменения)
                tableView.reloadRows(at: [selectedIndexPaht], with: .fade) // обновляем только нужную строку
            }
        }
    }
    
    
    // MARK: actions
    
    @IBAction func deleteFromTaskDetails(segue: UIStoryboardSegue) {
        guard segue.source is TaskDetailsController else {      // принимаем выховы только от TaskDetailsController - для более строго кода
            fatalError("Return from unknown source.")
        }
        
        if segue.identifier == "DeleteTaskFromDetails", let selectedIndexPath = tableView.indexPathForSelectedRow{
            deleteTask(selectedIndexPath)
        }
    }
    
    
    // MARK: DAO
    
    func deleteTask(_ indexPath: IndexPath) {
        taskDAO.delete(taskDAO.items[indexPath.row])
        taskDAO.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .top)
    }

}
