//
//  TaskDaoDbImpl.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 31/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation
import CoreData

class TaskDaoDbImpl: TaskDao {
   
    static let current = TaskDaoDbImpl()
    private init() {
        getAll()
    }
    
    let categoryDAO = CategoryDaoDbImpl.current
    let priorityDAO = PriorityDaoDbImpl.current
    
    var items:[Task]!
    
    func addOrUpdate(_ task: Task) {
        if !items.contains(task) {
            items.append(task)
        }
        save()
    }
    
    func getAll() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // добавляем поле для сортировки
        let sort = NSSortDescriptor(key: #keyPath(Task.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        fetchRequest.sortDescriptors = [sort]
        
        do {
            items = try context.fetch(fetchRequest)
        } catch {
            fatalError("Tasks fetch failed.")
        }
        
        return items
    }
    
    func delete(_ task: Task) {
        context.delete(task)
        save()
    }
    
    func search(text: String) -> [Task] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()       // объект-контейнер для выборки данных
        
        var params = [Any]()    // массив параметров лююого типа
        
        // прописываем само условие (без where)
        var sql = "name CONTAINS[c] %@"     // начало запроса, [c] - case insensitive
        
        params.append(text)
        
        // объект контейнер для добавления условий
        var predicate = NSPredicate(format: sql, argumentArray: params)
        
        fetchRequest.predicate = predicate      //добавляем предикат в контейнер запроса
        
        // можно создавать предикаты динамически и использовать нужный
        
        // добавляем поле для сортировки
        let sort = NSSortDescriptor(key: #keyPath(Task.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        fetchRequest.sortDescriptors = [sort]
        
        do {
            items = try context.fetch(fetchRequest)
        } catch {
            fatalError("Fetching failed!")
        }
        
        return items
    }
}
