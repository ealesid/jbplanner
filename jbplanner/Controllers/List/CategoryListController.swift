//
//  CategoryListController.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 06/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import UIKit

class CategoryListController: UIViewController, UITabBarDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let categoryDAO = CategoryDaoDbImpl.current
    
    var selectedCategory: Category!     // текущая категория задачи
    
    var delegate: ActionResultDelegate!            // нужен для возврата выбранной атегории в предыдущий контроллер
    
    var currentCheckedIndexPath: IndexPath!     // последний/текущий выбранный элемент
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryDAO.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath) as? CategoryListCell else {
            fatalError("CategoryCell fatal error")
        }
        
        let category = categoryDAO.items[indexPath.row]     // получаем кождую категорию по индексу
        
        
        if selectedCategory != nil && selectedCategory == category {
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
        
        // определение строки по координатам нажатия
        let viewPosition = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: viewPosition)!
        
        let category = categoryDAO.items[indexPath.row]
        
        if indexPath != currentCheckedIndexPath {       // если текущая строка не была выбрана
            selectedCategory = category
            
            if let currentCheckedIndexPath = currentCheckedIndexPath {      // снимаем выделение для прошлой выбранной строки
                tableView.reloadRows(at: [currentCheckedIndexPath], with: .none)    // обновляем ранее выбранную строку
            }
            
            currentCheckedIndexPath = indexPath         // запоминаем новый выбранный индекс
        } else {        // если строка уже была выделена - снимаем выделение
            selectedCategory = nil
            currentCheckedIndexPath = nil
        }
        
        // обновляем вид нажатой строки
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    @IBAction func tapSave(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        delegate?.done(source: self, data: selectedCategory)
    }
    
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
}
