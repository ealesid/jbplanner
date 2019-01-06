//
//  CategoryListController.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 06/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import UIKit

class CategoryListController: UIViewController, UITabBarDelegate, UITableViewDataSource {
    
    let categoryDAO = CategoryDaoDbImpl.current
    
    var selectedCategory: Category!     // текущая категория задачи
    
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
        } else {
            cell.buttonCheckCategory.setImage(UIImage(named: "check_gray"), for: .normal)
        }
        
        cell.labelCategoryName.text = category.name
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
