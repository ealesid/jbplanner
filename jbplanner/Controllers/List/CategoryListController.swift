//
//  CategoryListController.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 06/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import UIKit

class CategoryListController: DictionaryController<CategoryDaoDbImpl> {
    
    @IBOutlet weak var tableView: UITableView!      // ссылка на компонент
    @IBOutlet weak var labelHeaderTitle: UILabel!
    @IBOutlet weak var buttonSelectDeselect: UIButton!
    
        // MARK: tableView

    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.buttonSelectDeselectAll = buttonSelectDeselect
        super.dictTableView = tableView
        super.labelHeaderTitleDict = labelHeaderTitle
        
        dao = CategoryDaoDbImpl.current
        
        initNavBar()    // добавляем нужные кнопки на панель навигации
    }
    
    
    // заполенение таблицы данными
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath) as? CategoryListCell else {
            fatalError("CategoryCell fatal error")
        }
        
        let category = dao.items[indexPath.row]     // получаем кождую категорию по индексу

        cell.labelCategoryName.text = category.name
        cell.selectionStyle = .none     // чтобы строка не выделялась при нажатии
        cell.labelCategoryName.textColor = UIColor.darkGray
        labelHeaderTitle.textColor = UIColor.lightGray
        
        if showMode == .edit {
            buttonSelectDeselect.isHidden = false
            labelHeaderTitle.lineBreakMode = .byWordWrapping
            labelHeaderTitle.numberOfLines = 0
            labelHeaderTitle.text = "Check/uncheck categories to filter tasks."
            
            if category.checked {
                cell.buttonCheckCategory.setImage(UIImage(named: "check_green"), for: .normal)
            } else {
                cell.buttonCheckCategory.setImage(UIImage(named: "check_gray"), for: .normal)
            }
            
            tableView.allowsMultipleSelection = true
            
            if indexPath.row == dao.items.count - 1 { updateSelectDeselectButton() }
        } else if showMode == .select {
            tableView.allowsMultipleSelection = false
            
            buttonSelectDeselect.isHidden = true
            labelHeaderTitle.text = "Select one category for task"

            if selectedItem != nil && selectedItem == category {
                cell.buttonCheckCategory.setImage(UIImage(named: "check_green"), for: .normal)
                currentCheckedIndexPath = indexPath         // сохраняем выбранный индекс
            } else {
                cell.buttonCheckCategory.setImage(UIImage(named: "check_gray"), for: .normal)
            }
        }
        
        
        return cell
    }
    
    
    // нажатие на строку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRow:\t", indexPath, showMode)
        if showMode == .edit {
            editCategory(indexPath: indexPath)
            return
        }
        
        if showMode == .select {
            checkItem(indexPath)
            return
        }
    }
    
    func editCategory(indexPath: IndexPath) {
        DispatchQueue.main.async {
            let currentItem = self.dao.items[indexPath.row]
            let oldValue = currentItem.name
            
            self.showDialog(title: "Editing category", message: "Category name?:", initValue: currentItem.name!, actionClosure: { name in
                if !self.isEmptyTrim(name) { currentItem.name = name }
                else { currentItem.name = "New category" }
                
                if currentItem.name != oldValue {
                    self.updateItem(currentItem)
                    self.changed = true
                } else { self.changed = false }
            })
        }
    }
    
    override func addItemAction() {
        showDialog(title: "New category", message: "Category name?", actionClosure: { name in
            let category = Category(context: self.dao.context)
            
            if self.isEmptyTrim(name) { category.name = "New category" }
            else { category.name = name }
            self.addItem(category)
        })
    }
    
    

//     MARK: IBActions

    @IBAction func tapCheckCategory(_ sender: UIButton) {
        // определяем индекс строки по нажатому компоненту
        let viewPosition = sender.convert(CGPoint.zero, to: dictTableView)
        let indexPath = dictTableView.indexPathForRow(at: viewPosition)!
        checkItem(indexPath)
    }


    @IBAction func tapSave(_ sender: UIBarButtonItem) { save() }

    @IBAction func tapCancel(_ sender: UIBarButtonItem) { cancel() }
    
    @IBAction func tapSelectDeselect(_ sender: UIButton) { super.selectDeselectItems() }
    
    // методы получения списков объектов - вызываются из родительского класса
    
    // MARK: override
    override func getAll() -> [Category] {
        return dao.getAll(sortType: CategorySortType.name)
    }
    
    override func search(_ text: String) -> [Category] {
        return dao.search(text: text, sortType: CategorySortType.name)
    }
    
}
