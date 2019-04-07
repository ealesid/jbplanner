//
//  TaskDaoDbImpl.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 31/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation
import CoreData

class TaskDaoDbImpl: CommonSearchDAO {
   
    static let current = TaskDaoDbImpl()
    private init() {}
    
    typealias Item = Task
    typealias SortType = TaskSortType
    
    let categoryDAO = CategoryDaoDbImpl.current
    let priorityDAO = PriorityDaoDbImpl.current
    
    var items: [Item]!
    
    func addOrUpdate(_ task: Task) {
        if !items.contains(task) {
            items.append(task)
        }
        save()
    }
    
    
    // MARK: DAO
    
    func getAll(sortType: SortType?) -> [Task] {
        let fetchRequest: NSFetchRequest<Item> = Task.fetchRequest()
        
        // добавляем поле для сортировки
        if let sortType = sortType {
            fetchRequest.sortDescriptors = [sortType.getDescriptor(sortType)]
        }
        
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
    
    func search(text: String, sortType: SortType?) -> [Task] {
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
        if let sortType = sortType {
            fetchRequest.sortDescriptors = [sortType.getDescriptor(sortType)]
        }

        do {
            items = try context.fetch(fetchRequest)
        } catch {
            fatalError("Fetching failed!")
        }
        
        return items
    }
}


// возможные поля для сортировки списка задач
enum TaskSortType: Int {
    // порядок case'ов должен совпадать с порядком кнопок сортировки (scope buttons)
    case name = 0
    case priority
    case deadline
    
    // получить объект для сортировки для добавления в fetchRequest
    func getDescriptor(_ sortType: TaskSortType) -> NSSortDescriptor {
        switch sortType {
        case .name:
            return NSSortDescriptor(key: #keyPath(Task.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        case .deadline:
            return NSSortDescriptor(key: #keyPath(Task.deadline), ascending: true)
        case .priority:
            return NSSortDescriptor(key: #keyPath(Task.priority.index), ascending: false)       // ascending: false - high priority вверху списка
        }
    }
}
