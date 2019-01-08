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
    
        // MARK: tableView

    override func viewDidLoad() {
        super.viewDidLoad()
        dictTableView = tableView
        dao = CategoryDaoDbImpl.current
    }
    
    
    // заполенение таблицы данными
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath) as? CategoryListCell else {
            fatalError("CategoryCell fatal error")
        }
        
        cell.selectionStyle = .none     // чтобы строка не выделялась при нажатии
        
        let category = dao.items[indexPath.row]     // получаем кождую категорию по индексу
        
        
        if selectedItem != nil && selectedItem == category {
            cell.buttonCheckCategory.setImage(UIImage(named: "check_green"), for: .normal)
            currentCheckedIndexPath = indexPath         // сохраняем выбранный индекс
        } else {
            cell.buttonCheckCategory.setImage(UIImage(named: "check_gray"), for: .normal)
        }
        
        cell.labelCategoryName.text = category.name
        
        return cell
    }
    
    
    // MARK: IBActions
    
    @IBAction func tapCheckCategory(_ sender: UIButton) {
        checkItem(sender)
    }
    
    
    @IBAction func tapSave(_ sender: UIBarButtonItem) {
        save()
    }
    
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        cancel()
    }
    
}
