//
//  TaskListController.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 24/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import CoreData
import UIKit

class TaskListController: UITableViewController {
    
    let dateFormatter = DateFormatter()
    
    var context: NSManagedObjectContext! // контекст для связи объектов с БД
    
    // временный массив данных
//    private var taskList:[Task] = [
//        Task(name: "1st Task", category: "1st Category"),
//        Task(name: "2nd Task", category: "2nd Category", priority: "High"),
//        Task(name: "3rd Task", category: "3rd Category", deadLine: Date())
//    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        // используем AppDelegate для получения доступа к контексту
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("appDelegate error")
        }
        
        // получаем контекст из persistentContainer
        context = appDelegate.persistentContainer.viewContext

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
        return 1
    }

    // отображение данных в строке
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as? TaskListCell else {
            fatalError("Cell Type Error")
        }

        let cat1 = addCategory(name: "Sport")
        let cat2 = addCategory(name: "Family")
        let cat3 = addCategory(name: "Vacation")

        let priority1 = addPriority(name: "Low", index: 1)
        let priority2 = addPriority(name: "Meduim", index: 2)
        let priority3 = addPriority(name: "High", index: 3)
        
        let task1 = addTask(name: "Visit swimpool", completed: false, deadline: Date(), info: "additional info", category: cat1, priority: priority2)
        let task2 = addTask(name: "Weekend with family", completed: false, deadline: Date(), info: "additional info", category: cat2, priority: priority1)

        return cell
    }
    
    func addCategory(name: String) -> Category {
        let category = Category(context: context)
        category.name = name
        do {
            try context.save()
        } catch let error as NSError {
            print("Category could not save : \(error)")
        }
        
        return category
    }
    
    func addPriority(name: String, index: Int32) -> Priority {
        let priority = Priority(context: context)
        priority.name = name
        priority.index = index
        do {
            try context.save()
        } catch let error as NSError {
            print("Priority could not save : \(error)")
        }
        
        return priority
    }
    
    func addTask(name: String, completed: Bool, deadline: Date?, info: String?, category: Category?, priority: Priority?) -> Task {
        let task = Task(context: context)
        task.name = name
        task.completed = completed
        task.deadline = deadline
        task.info = info
        task.category = category
        task.priority = priority
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Task could not save: \(error)")
        }
        
        return task
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
