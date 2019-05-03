import UIKit
import SwiftIconFont



class TaskDetailsController: UIViewController, UITableViewDataSource, UITableViewDelegate, ActionResultDelegate {
    
    @IBOutlet weak var buttonTaskComplete: UIButton!
    @IBOutlet weak var buttonTaskDelete: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // текущая задача для редактирования
    var task: Task!
    
    // поля задачи (в них будут хранится последние изменные значения, в случае сохранения - эти данные запишутся в task)
    var taskName: String?
    var taskInfo: String?
    var taskPriority: Priority?
    var taskCategory: Category?
    var taskDeadline: Date?
    
    let taskNameSection = 0
    let taskCategorySection = 1
    let taskPrioritySection = 2
    let taskDeadlineSection = 3
    let taskInfoSection = 4
    
    var delegate: ActionResultDelegate! // нужен для уведомления и вызова функции из контроллера списка задач
    
    // сохраняем ссылки на компоненты
    var textTaskName: UITextField!
    var textViewTaskInfo: UITextView!
    var buttonDatetimePicker: UIButton!
    
    var dateFormatter: DateFormatter!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dateFormatter = createDateFormatter()
        
        // сохраняем в соответствующие переменные все данные задачи
        if let task = task {    // если объект не пустой (значит, режим редактирования, а не создания новой задачи)
            taskName = task.name
            taskInfo = task.info
            taskPriority = task.priority
            taskCategory = task.category
            taskDeadline = task.deadline
        }
        
        hideKeyboardWhenTypingAround()
        
        initTaskButtons()
    }
    
    
    //    MARK: init
    
    func initTaskButtons() {
        buttonTaskComplete.titleLabel?.font = UIFont.icon(from: .fontAwesome, ofSize: 18.0)
        buttonTaskComplete.titleLabel?.tintColor = UIColor.white
        buttonTaskComplete.setTitle(String.fontAwesomeIcon("check"), for: .normal)

        buttonTaskDelete.titleLabel?.font = UIFont.icon(from: .fontAwesome, ofSize: 18.0)
        buttonTaskDelete.titleLabel?.tintColor = UIColor.white
        buttonTaskDelete.setTitle(String.fontAwesomeIcon("trash"), for: .normal)
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
        case taskNameSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskName", for: indexPath) as? TaskNameCell else {
                fatalError("Cell Type Error")
            }
            cell.textTaskName.text = taskName
            
            if (cell.textTaskName.text?.isEmpty)! { cell.textTaskName.becomeFirstResponder() }
            
            textTaskName = cell.textTaskName // для использования компонента вне метода tableView
            
            return cell
            
        case taskCategorySection: // category
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskCategory", for: indexPath) as? TaskCategoryCell else {
                fatalError("Cell Type Error")
            }
            
            var value: String
            
            if let name = taskCategory?.name {
                value = name
                cell.labelTaskCategory.textColor = UIColor.darkText
            } else {
                value = "Not slelected"
                cell.labelTaskCategory.textColor = UIColor.lightGray
            }
            
            cell.labelTaskCategory.text = value
            return cell
            
        case taskPrioritySection: // priority
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

        case taskDeadlineSection: // deadline
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskDeadline", for: indexPath) as? TaskDeadlineCell else {
                fatalError("Cell Type Error")
            }
            
            cell.selectionStyle = .none
                        
            var value: String
            
            if let deadline = taskDeadline {
                value = dateFormatter.string(from: deadline)
                cell.buttonDateTimePicker.setTitleColor(UIColor.gray, for: .normal)
                cell.buttonClearDeadline.isHidden = false
            } else {
                value = "No deadline."
                cell.buttonDateTimePicker.setTitleColor(UIColor.lightGray, for: .normal)
                cell.buttonClearDeadline.isHidden = true
            }
            
            // заполняем компонент данными из задачи
            cell.buttonDateTimePicker.setTitle(value, for: .normal)
            
            // текст и стиль для разницы в днях
            handleDaysDiff(taskDeadline?.offsetFrom(date: Date().today), label: cell.labelDaysDiff)
            
            return cell

        case taskInfoSection: // additional info
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
        case taskNameSection:
            return "Name"
        case taskCategorySection:
            return "Category"
        case taskPrioritySection:
            return "Priority"
        case taskDeadlineSection:
            return "Deadline"
        case taskInfoSection:
            return "Additional Info"
            
        default:
            return ""
            
        }
    }
    
    // MARK: IBActions
    
    // закрытие контроллера без сохранения
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        closeController()
    }
    
    @IBAction func tapSave(_ sender: UIBarButtonItem) {
        
        if let taskName = taskName?.trimmingCharacters(in: .whitespacesAndNewlines), !taskName.isEmpty {
            task.name = taskName
        } else { task.name = "New Task" }
            
        task.info = taskInfo
        task.category = taskCategory
        task.priority = taskPriority
        task.deadline = taskDeadline
        
        delegate.done(source: self, data: task)      // можно не передавать обратно task, т.к. reference type
        
        closeController()
    }
    
    @IBAction func taskNameChanged(_ sender: UITextField) {
        taskName = sender.text
    }
    
    @IBAction func tapClearDeadline(_ sender: UIButton) {
        taskDeadline = nil
        tableView.reloadRows(at: [IndexPath(row: 0, section: taskDeadlineSection)], with: .fade)
    }
    
    @IBAction func tapDeleteTask(_ sender: UIButton) {
//        confirmAction(title: "Delete confirmation", text: "Delete selected task?", segue: "DeleteTaskFromDetails")
        confirmAction(text: "Delete selected task?") { self.performSegue(withIdentifier: "DeleteTaskFromDetails", sender: self) }
    }
    
    @IBAction func tapCompleteTask(_ sender: UIButton) {
//        confirmAction(title: "Complete confirmation", text: "Complete selected task?", segue: "CompleteTaskFromDetails")
        confirmAction(text: "Complete selected task?") { self.performSegue(withIdentifier: "CompleteTaskFromDetails", sender: self) }
    }
    
    func confirmAction(title: String, text: String, segue: String) {
        let dialogMessage = UIAlertController(title: title, message: text, preferredStyle: .actionSheet)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: segue, sender: self)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)

    }
    
    @IBAction func tapDatetimePicker(_ sender: UIButton) {
    }
    
    // MARK: prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == nil { return }
        
        switch segue.identifier {
        case "selectCategory":
            if let controller = segue.destination as? CategoryListController {
                controller.selectedItem = taskCategory     // передаем текущее значение категории
                controller.delegate = self
                controller.showMode = .select
                controller.navigationTitle = "Select category"
            }
            
        case "selectPriority":
            if let controller = segue.destination as? PriorityListController {
                controller.selectedItem = taskPriority     // передаем текущее значение категории
                controller.delegate = self
                controller.showMode = .select
                controller.navigationTitle = "Select priority"
            }
            
        case "editTaskInfo":
            if let controller = segue.destination as? TaskInfoController {
                controller.taskInfo = taskInfo
                controller.delegate = self
            }
            
        case "selectDatetime":
            if let controller = segue.destination as? DatetimePickerController {
                controller.initDeadline = taskDeadline
                controller.delegate = self
            }
            
        default:
            return
        }
    }
    
    
    // MARK: ActionResultDelegate
    
    func done(source: UIViewController, data: Any?) {
        
        switch source {
        case is CategoryListController:
            taskCategory = data as? Category
            tableView.reloadRows(at: [IndexPath(row: 0, section: taskCategorySection)], with: .fade)
            
        case is PriorityListController:
            taskPriority = data as? Priority
            tableView.reloadRows(at: [IndexPath(row: 0, section: taskPrioritySection)], with: .fade)
            
        case is TaskInfoController:
            taskInfo = data as? String
            textViewTaskInfo.text = taskInfo
            
        case is DatetimePickerController:
            taskDeadline = data as? Date
            tableView.reloadRows(at: [IndexPath(row: 0, section: taskDeadlineSection)], with: .fade)
            
        default:
            print()
        }
    }
}

