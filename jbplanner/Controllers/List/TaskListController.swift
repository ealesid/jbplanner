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
    
    let quickTaskSection = 0
    let taskListSection = 1
    
    let sectionCount = 2
    
    var textQuickTask: UITextField!     // ссылка на текстовый компонент
    
    var taskCount: Int { return taskDAO.items.count }
    
    
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
        return sectionCount
    }

    // количество записей в каждой секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case quickTaskSection:
            return 1
        case taskListSection:
            return taskCount
        default:
            return 0
        }

    }

    // отображение данных в строке
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case quickTaskSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellQuickTask", for: indexPath) as? QuickTaskCell else {
                fatalError("cellQuickTask fatal error")
            }
            
            textQuickTask = cell.textQuickTask
            textQuickTask.placeholder = "Type here to start new Task"
            
            return cell
            
        case taskListSection:
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
            
            // стиль для завершенных задач
            if task.completed {
                cell.labelDeadLine.textColor = .lightGray
                cell.labelTaskName.textColor = .lightGray
                cell.labelTaskCategory.textColor = .lightGray
                cell.labelPriority.backgroundColor = .lightGray
                cell.buttonCompleteTask.setImage(UIImage(named: "check_green"), for: .normal)
                cell.selectionStyle = .none
                cell.buttonTaskInfo.isEnabled = false
                cell.buttonTaskInfo.imageView?.image = UIImage(named: "note_gray")
            } else {        // стиль для незавершенных задач
                cell.selectionStyle = .default
                cell.buttonTaskInfo.isEnabled = true
                cell.buttonTaskInfo.imageView?.image = UIImage(named: "note")
                cell.labelTaskName.textColor = .darkGray
                cell.buttonCompleteTask.setImage(UIImage(named: "check_gray"), for: .normal)
                cell.buttonTaskInfo.isEnabled = true
            }
            
            return cell

        default:
            return UITableViewCell()        // пустая ячейка
        }
        
    }
    
    // установка высоты строки
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case quickTaskSection:
            return 40
        default:
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == quickTaskSection { return false }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteTask(indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appripriate class, insert it into the array, and add a new row to the tableView
            
        }
    }
    
    // переход к редактированию, если задача не завершена
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if taskDAO.items[indexPath.row].completed == true { return }        // если задача не завершена - выходим из метода
        
        if indexPath.section != quickTaskSection {
            // переход в контроллер для редактирования задачи
            performSegue(withIdentifier: "updateTask", sender: tableView.cellForRow(at: indexPath))
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
            
        case "CreateTask":
            // получаем доступ к целевому контроллеру
            guard let controller = segue.destination as? TaskDetailsController else { fatalError("Wrong controller") }
            controller.title = "New Task"
            controller.task = Task(context: taskDAO.context)
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
            } else {    // создаем новую задачу
                let task = data as! Task
                
                createTask(task)
            }
        }
    }
    
    
    // MARK: actions

    @IBAction func deleteFromTaskDetails(segue: UIStoryboardSegue) {
        guard segue.source is TaskDetailsController else {      // принимаем выховы только от TaskDetailsController - для более строго кода
            fatalError("Return from unknown source.")
        }
        
        if segue.identifier == "DeleteTaskFromDetails", let selectedIndexPath = tableView.indexPathForSelectedRow {
            deleteTask(selectedIndexPath)
        }
    }
    
    @IBAction func completeFromTaskDetails(segue: UIStoryboardSegue) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow { completeTask(selectedIndexPath) }
    }

    @IBAction func tapCompleteTask(_ sender: UIButton) {
        // определяем индекс строки по нажатому компоненту
        let viewPosition = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = self.tableView.indexPathForRow(at: viewPosition)!
        completeTask(indexPath)
    }
    
    
    @IBAction func quickTaskAdd(_ sender: UITextField) {
        var task = Task(context: taskDAO.context)
        task.name = textQuickTask.text
        
        if let name = textQuickTask.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty {
            task.name = name
        } else {
            task.name = "New Task"
        }
        
        createTask(task)
        textQuickTask.text = ""
        
    }
    
    func completeTask(_ indexPath: IndexPath) {
        
        // принимаем вызовы только от TaskLIstCell
        guard (tableView.cellForRow(at: indexPath) as? TaskListCell) != nil else {
            fatalError("Cell Type Error")
        }
        
        //обновляем вид строки
        let task = taskDAO.items[indexPath.row]
        task.completed = !task.completed
        taskDAO.addOrUpdate(task)
        
        tableView.reloadRows(at: [indexPath], with: .fade)

    }
    
    func createTask(_ task: Task){
        taskDAO.addOrUpdate(task)
        
        // индекс чтобы задача добавилась в конец списка
        let indexPath = IndexPath(row: taskCount-1, section: taskListSection)
        tableView.insertRows(at: [indexPath], with: .top)

    }
    
    
    
    // MARK: DAO
    
    func deleteTask(_ indexPath: IndexPath) {
        taskDAO.delete(taskDAO.items[indexPath.row])
        taskDAO.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .top)
    }

}
