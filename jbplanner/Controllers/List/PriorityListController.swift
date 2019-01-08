//
//  PriorityListController.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 06/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import UIKit

class PriorityListController: DictionaryController<PriorityDaoDbImpl> {
        
    @IBOutlet weak var tableView: UITableView!


    // MARK: tableView

    override func viewDidLoad() {
        super.viewDidLoad()
        dao = PriorityDaoDbImpl.current
        dictTableView = tableView
    }
    
    // заполнение таблицы
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellPriority", for: indexPath) as? PriorityListCell else {
            fatalError("PriorityCell fatal error")
        }
        
        cell.selectionStyle = .none
        
        let priority = dao.items[indexPath.row]     // получаем кождую категорию по индексу
        
        
        if selectedItem != nil && selectedItem == priority {
            cell.buttonCheckPriority.setImage(UIImage(named: "check_green"), for: .normal)
            currentCheckedIndexPath = indexPath         // сохраняем выбранный индекс
        } else {
            cell.buttonCheckPriority.setImage(UIImage(named: "check_gray"), for: .normal)
        }
        
        cell.labelPriorityName.text = priority.name
        
        return cell
    }
    
    
    // MARK: IBActions
    
    @IBAction func tapCheckPriority(_ sender: UIButton) {
        checkItem(sender)
    }
    
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        cancel()
    }
    
    @IBAction func tapSave(_ sender: UIBarButtonItem) {
        save()
    }
}
