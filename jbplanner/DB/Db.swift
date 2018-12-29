//
//  Db.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 29/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Db {
    
    // получаем контекст из persistentContainer
    var context: NSManagedObjectContext! // контекст для связи объектов с БД
    
    init() {
        // используем AppDelegate для получения доступа к контексту
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("appDelegate error")
        }
        
        // получаем контекст из persistentContainer
        context = appDelegate.persistentContainer.viewContext
    }
    
    func initData() {
        let cat1 = addCategory(name: "Sport")
        let cat2 = addCategory(name: "Family")
        let cat3 = addCategory(name: "Vacation")
        
        let priority1 = addPriority(name: "Low", index: 1)
        let priority2 = addPriority(name: "Meduim", index: 2)
        let priority3 = addPriority(name: "High", index: 3)
        
        let task1 = addTask(name: "Visit swimpool", completed: false, deadline: Date(), info: "additional info", category: cat1, priority: priority2)
        let task2 = addTask(name: "Weekend with family", completed: false, deadline: Date().rewindDays(2), info: "additional info", category: cat2, priority: priority1)
    }
    
    func deleteTask(task: Task) {
        context.delete(task)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not delete task from database: \(error)")
        }
    }

    
    func getAllTasks() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let list:[Task]
        
        do {
            list = try context.fetch(fetchRequest)
        } catch {
            fatalError("Task fetch failed!")
        }
        
        return list
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
    
}
