import CoreData
import UIKit
import SideMenu
import Toaster


class TaskListController: UITableViewController, ActionResultDelegate {
    
//    let db = Db()
    
    let taskDAO = TaskDaoDbImpl.current
    let categoryDAO = CategoryDaoDbImpl.current
    let priorityDAO = PriorityDaoDbImpl.current
    
    var searchController: UISearchController!       // область поиска, которая будет добавляться поверх таблицы списка задач
    
    let quickTaskSection = 0
    let taskListSection = 1
    
    let sectionCount = 2
    
    var textQuickTask: UITextField!     // ссылка на текстовый компонент
    
    var taskCount: Int { return taskDAO.items.count }
    
    var dateFormatter: DateFormatter!
    
    var currentScopeIndex = 0           // текущая выбранная кнопка сортировки в search bar
    
    var searchBarActive = false
    
    var searchBar: UISearchBar { return searchController.searchBar }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter = createDateFormatter()
        
        currentScopeIndex = PrefsManager.current.sortType   // сохраненный тип сортировки
        
        taskDAO.getAll(sortType: TaskSortType(rawValue: currentScopeIndex)!)

        setupSearchController()
        
        initIcons()
        
        initSideMenu()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTable()
    }
    
    
    //    MARK: init
    
    func initIcons() {
        navigationItem.rightBarButtonItem?.icon(from: .themify, code: "plus", ofSize: 20)
        navigationItem.leftBarButtonItem?.icon(from: .themify, code: "menu", ofSize: 20)
    }
    
    
    // MARK: - Side Menu
    func initSideMenu() {
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "SideMenu") as? UISideMenuNavigationController
        
        // не затемняем верхний статус бар
        SideMenuManager.default.menuFadeStatusBar = false
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
            cell.labelTaskCategory.textColor = UIColor.lightGray

            if let priority = task.priority { cell.labelPriority.backgroundColor = priority.color as? UIColor }
            else { cell.labelPriority.backgroundColor = UIColor.white }
            
            cell.labelDeadLine.textColor = .lightGray
            
            // отображать или нет иконку блокнота
            if task.info == nil || (task.info?.isEmpty)! {
                cell.buttonTaskInfo.isHidden = true
            } else {
                cell.buttonTaskInfo.isHidden = false
            }
            
            // текст и стиль для отображения разниуы в днях
            handleDaysDiff(task.daysLeft(), label: cell.labelDeadLine)
                        
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
            controller.mode = TaskDetailsMode.update
            
        case "CreateTask":
            // получаем доступ к целевому контроллеру
            guard let controller = segue.destination as? TaskDetailsController else { fatalError("Wrong controller") }
            controller.title = "New Task"
            controller.task = Task(context: taskDAO.context)
            controller.delegate = self
            controller.mode = TaskDetailsMode.add
            
        case "showTaskInfo":
            
            let button = sender as! UIButton
            let buttonPosition = button.convert(CGPoint.zero, to: self.tableView)
            let indexPath = self.tableView.indexPathForRow(at: buttonPosition)!
            
            let selectedTask = taskDAO.items[indexPath.row]
            
            guard let controller = segue.destination as? TaskInfoController else {fatalError("TaskInfoController error") }
            controller.taskInfo = selectedTask.info
//            controller.delegate = self
            controller.navigationTitle = selectedTask.name
            controller.taskInfoShowMode = .readonly
            
            
        default:
            return
        }
    }
    
    // MARK: ActionResultDelegate
    
    // может обрабатывать ответы (слушать действия) от любых контроллеров
    func done(source: UIViewController, data: Any?) {
        
        guard let controller = source as? TaskDetailsController else { fatalError("fatal error with cell") }
        
        let task = data as! Task
        switch controller.mode {
        case .add?: createTask(task)
        case .update?: updateTask(task)
        default: return
        }
        
//        // если пришел ответт от TaskDetailsController
//        if source is TaskDetailsController {
//            if let selectedIndexPaht = tableView.indexPathForSelectedRow { // определяем выбранную строку
//                let task = data as! Task
//                taskDAO.update(task)
////                taskDAO.save() // сохраняем измененную задачу (сохраняет все изменения)
////                tableView.reloadRows(at: [selectedIndexPaht], with: .fade) // обновляем только нужную строку
//            } else {    // создаем новую задачу
//                let task = data as! Task
//                createTask(task)
//            }
//
//            updateTable()
//        }
    }
    
    
    // MARK: actions
    
    @IBAction func updateTasks(segue: UIStoryboardSegue) {
        if let source = segue.source as? FiltersController, source.changed, segue.identifier == "filterTasks" { // если были изменения в фильтрах
            updateTable()
        }
        
        if let source = segue.source as? CategoryListController, source.changed, segue.identifier == "updateTaskCategories" {  // если были изменения при редактировании категорий
            updateTable()
        }
        
        if let source = segue.source as? PriorityListController, source.changed, segue.identifier == "updateTaskPriorities" {
            updateTable()
        }
    }

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
        
        if isEmptyTrim(textQuickTask.text) { return }
        
        let task = Task(context: taskDAO.context)
        
        createTask(task)
//        updateTable()
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

        // анимация сокрытия строк
        // TODO: Fix invalid number of sections during delete of section
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            if !PrefsManager.current.showCompletedTasks {   // если отключен показ завершенных задач
                
                // удаляем задачу из коллекции и из таблицы
                self.taskDAO.items.remove(at: indexPath.row)

                self.tableView.deleteRows(at: [indexPath], with: .top)

//                if self.taskDAO.items.isEmpty { // если это последняя запись - удаляем всю секцию
//                    self.tableView.deleteSections(IndexSet([self.taskListSection]), with: .top)
//                } else {
//                    self.tableView.deleteRows(at: [indexPath], with: .top)
//                }
            }
        }
    }
    
    func createTask(_ task: Task){
        taskDAO.add(task)
        tryUpdate(task, forceUpdate: false, text: "Task added,\nbut not visible because of filter:\n")
        
        // индекс чтобы задача добавилась в конец списка
        let indexPath = IndexPath(row: taskCount-1, section: taskListSection)
        tableView.insertRows(at: [indexPath], with: .top)
    }
    
    
    // MARK: - updateTable
    
    func updateTask(_ task: Task) {
        taskDAO.update(task)
        tryUpdate(task, forceUpdate: true, text: "Task updated,\nbut not visible because of filter:\n")
    }

    func tryUpdate(_ task: Task, forceUpdate: Bool, text: String) {
        
        var willShow = true
        var text = text
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            
            if !PrefsManager.current.showCompletedTasks && task.completed == true { willShow = false }
            else
                if !PrefsManager.current.showEmptyCategories && task.category == nil {
                    willShow = false
                    text += "\"Hide tasks with empty category\""
                }
                else
                    if !PrefsManager.current.showEmptyPriorities && task.priority == nil {
                        willShow = false
                        text += "\"Hide tasks with empty priority\""
                    }
                    else
                        if !PrefsManager.current.showTasksWithoutDate && task.deadline == nil {
                            willShow = false
                            text += "\"Hide tasks withot date\""
                        }
                        else
                            if let category = task.category, !self.categoryDAO.checkedItems().contains(category) {
                                willShow = false
                                text += "\"Hide category \(category)\""
                            }
                            else
                                if let priority = task.priority, !self.priorityDAO.checkedItems().contains(priority) {
                                    willShow = false
                                    text += "\"Hide priorirty \(priority)\""
                                }
                                else
                                    if (self.searchBarActive && task.name?.lowercased().range(of: self.searchBar.text!.lowercased()) == nil) {
                                        willShow = false
                                        text += "\"Name does not contains \(self.searchBar.text)\""
            }
            
            if willShow { self.updateTable() }
            else {
                if forceUpdate {self.updateTable() }
                Toast(text: text, delay: 0, duration: Delay.long).show()
            }
        }
    }
    
    func updateTable() {
        
        let sortType = TaskSortType(rawValue: currentScopeIndex)!   // определяем тип сортировки  по текущему выбранному значению
        
        if searchBarActive && searchController.searchBar.text != nil && !(searchController.searchBar.text?.isEmpty)! {  // если активен режим поиска и текст не пустой
            taskDAO.search(
                text: searchController.searchBar.text!, categories: categoryDAO.checkedItems(), priorities: priorityDAO.checkedItems(), sortType: sortType,
                showTasksEmptyPriorities: PrefsManager.current.showEmptyPriorities, showTasksEmptyCategories: PrefsManager.current.showEmptyCategories, showCompletedTasks: PrefsManager.current.showCompletedTasks, showTasksWithoutDate: PrefsManager.current.showTasksWithoutDate
            )
        } else {
            taskDAO.search(
                text: nil, categories: categoryDAO.checkedItems(), priorities: priorityDAO.checkedItems(), sortType: sortType,
                showTasksEmptyPriorities: PrefsManager.current.showEmptyPriorities, showTasksEmptyCategories: PrefsManager.current.showEmptyCategories, showCompletedTasks: PrefsManager.current.showCompletedTasks, showTasksWithoutDate: PrefsManager.current.showTasksWithoutDate
            )
        }
        
        tableView.reloadData()
        
        updateTableBackground(tableView, count: taskCount)
    }
    
    
    
    // MARK: DAO
    
    func deleteTask(_ indexPath: IndexPath) {
        taskDAO.delete(taskDAO.items[indexPath.row])
        taskDAO.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .top)
    }

}


// настройка searchController и обработка действий при поиске
extension TaskListController: UISearchResultsUpdating {
    
    // метод делегата вызывается автоматически для каждой буквы поиска
    // или когда пользователь просто активирует поиск
    func updateSearchResults(for searchController: UISearchController) {
        // не будем использовать этот метод поиска
        // будем искать только после нажатия Enter
    }
    
}

extension TaskListController: UISearchBarDelegate {
    
    // добавление search bar к таблице
    func setupSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)     // searchResultsController: nil - т.к. результаты будут сразу отображаться в этом же view
        
        searchController.dimsBackgroundDuringPresentation = false       // затемнять фон или нет при поиске, при затемнении не доступен выбор найденной записи
        
        // для правильного отображения внутри таблицы
        // подробнее: http://www.thomasdenney.co.uk/blog/2014/10/5/uisearchcontroller-and-definepresentationcontext/
        definesPresentationContext = true
        
        searchController.searchBar.placeholder = "Search by name"
        searchController.searchBar.backgroundColor = .white
        
        searchController.searchBar.scopeButtonTitles = ["A-Z", "Priority", "Date"]      // добавляем scope buttons
        searchController.searchBar.selectedScopeButtonIndex = currentScopeIndex         // выделяем выбранную scope button
        
        // обработка действий поиска и работа с search bar в этом же классе
        // searchController.searchResultsUpdater = self     // так как не используем
        searchController.searchBar.delegate = self
        
        // сразу не показывать segmented controls для сортировки результата
        // такой подход связан с багом, когда компоненты налезают друг на друга
        searchController.searchBar.showsScopeBar = false
        
        // из-за бага в работе searchController применяем разные способы добавления searchBar в зависимости от версии iOS
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    // обязываем пользователя нажимать Enter для поиска
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    // начали редактировать текст поиска
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarActive = true      // есть также метод searchBar.isActive, но значение в него может быть записано позднее, чем это нужно
    }
    
    // поиск после окончания ввода данных (нажатия на Enter/Search)
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        updateTable()
    }
    
    // нажимаем Cancel - возвращаем все данные
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !searchController.searchBar.showsScopeBar {
            searchController.searchBar.showsScopeBar = true
        }
        
        searchBarActive = false
        searchController.searchBar.text = ""
        
        updateTable()
    }
    
    // переключение между кнопками сортировки
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        if currentScopeIndex == selectedScope { return }        // если значение не изменилось (нажали уже активную кнопку) - ничего не делаем
        currentScopeIndex = selectedScope                       // сохраняем выбранный scope button
        PrefsManager.current.sortType = currentScopeIndex       // сохраняем в настройки приложения
        updateTable()
    }
}
