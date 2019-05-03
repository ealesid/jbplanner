//
//  PriorityListController.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 06/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import UIKit

class PriorityListController: DictionaryController<PriorityDaoDbImpl>, ActionResultDelegate {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    @IBOutlet weak var buttonSelectDeselect: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.buttonSelectDeselectAll = buttonSelectDeselect
        super.dictTableView = tableView
        super.labelHeaderTitleDict = labelHeaderTitle

        dao = PriorityDaoDbImpl.current
        
        initNavBar()
    }
    

    // MARK: tableView

    // заполнение таблицы
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellPriority", for: indexPath) as? PriorityListCell else {
            fatalError("PriorityCell fatal error")
        }
        
        cell.selectionStyle = .none
        
        let priority = dao.items[indexPath.row]     // получаем кождую категорию по индексу
                
        cell.labelPriorityName.text = priority.name
        cell.selectionStyle = .none     // чтобы строка не выделялась при нажатии
        cell.labelPriorityName.textColor = UIColor.darkGray
        labelHeaderTitle.textColor = UIColor.lightGray

        if let color = priority.color {
            cell.labelPriorityColor.backgroundColor = color as! UIColor
        }

        if showMode == .edit {
            buttonSelectDeselect.isHidden = false
            labelHeaderTitle.lineBreakMode = .byWordWrapping
            labelHeaderTitle.numberOfLines = 0
            labelHeaderTitle.text = "Check/uncheck priorities to filter tasks."

            if priority.checked {
                cell.buttonCheckPriority.setImage(UIImage(named: "check_green"), for: .normal)
            } else {
                cell.buttonCheckPriority.setImage(UIImage(named: "check_gray"), for: .normal)
            }

            tableView.allowsMultipleSelection = true

            if indexPath.row == dao.items.count - 1 { updateSelectDeselectButton() }
        } else if showMode == .select {
            tableView.allowsMultipleSelection = false

            buttonSelectDeselect.isHidden = true
            labelHeaderTitle.text = "Select prioriry for task"

            if selectedItem != nil && selectedItem == priority {
                cell.buttonCheckPriority.setImage(UIImage(named: "check_green"), for: .normal)
                currentCheckedIndexPath = indexPath         // сохраняем выбранный индекс
            } else {
                cell.buttonCheckPriority.setImage(UIImage(named: "check_gray"), for: .normal)
            }
        }
        
        return cell
    }
    
    
//    MARK: IBActions

    @IBAction func tapCheckPriority(_ sender: UIButton) {
        // определяем индекс строки по нажатому компоненту
        let viewPosition = sender.convert(CGPoint.zero, to: dictTableView)
        let indexPath = dictTableView.indexPathForRow(at: viewPosition)!
        checkItem(indexPath)
    }

    @IBAction func tapCancel(_ sender: UIBarButtonItem) { cancel() }

    @IBAction func tapSave(_ sender: UIBarButtonItem) { save() }
    
    @IBAction func tapSelectDeselect(_ sender: UIButton) { super.selectDeselectItems() }
    
    // методы получения списков объектов - вызываются из родительского класса
    
    
    // MARK: prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPriority" {
            guard let controller = segue.destination as? EditPriorityController else { fatalError("EditPriorityController error") }
            controller.priority = dao.items[tableView.indexPathForSelectedRow!.row]
            controller.navigationTitle = "Edit priority"
            controller.delegate = self
            return
        }
        
        if segue.identifier == "addPriority" {
            guard let controller = segue.destination as? EditPriorityController else { fatalError("EditPriorityController error") }
            controller.navigationTitle = "New priority"
            controller.delegate = self
            return
        }
    }

    
//    MARK: ActionResultDelegate
    
    func done(source: UIViewController, data: Any?) {
        if source is EditPriorityController {
            let priority = data as! Priority
            if let selectedIndexPath = tableView.indexPathForSelectedRow { updateItem(priority, indexPath: selectedIndexPath)}
            else { addItem(priority) }
            
            changed = true
        }
    }
    
    
    // MARK: override
    
    override func addItemAction() { performSegue(withIdentifier: "addPriority", sender: self) }
    override func editItemAction(indexPath: IndexPath) { performSegue(withIdentifier: "editPriority", sender: self) }
    
    override func getAll() -> [Priority] {
        return dao.getAll(sortType: PrioritySortType.index)
    }

    override func search(_ text: String) -> [Priority] {
        return dao.search(text: text, sortType: PrioritySortType.index)
    }

}
