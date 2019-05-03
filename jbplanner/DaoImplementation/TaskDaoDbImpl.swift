//
//  TaskDaoDbImpl.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 31/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation
import CoreData

class TaskDaoDbImpl: TaskSearchDAO {
    
    static let current = TaskDaoDbImpl()
    private init() {}

    typealias CategoryItem = Category
    typealias PriorityItem = Priority
        
    typealias Item = Task
    typealias SortType = TaskSortType
    
    let categoryDAO = CategoryDaoDbImpl.current
    let priorityDAO = PriorityDaoDbImpl.current
    
    var items: [Item]!
    

    // MARK: - dao
    
    func getAll(sortType: SortType?) -> [Task] {
        let fetchRequest: NSFetchRequest<Item> = Task.fetchRequest()
        
        // добавляем поле для сортировки
        if let sortType = sortType { fetchRequest.sortDescriptors = [sortType.getDescriptor(sortType)] }
        
        do { items = try context.fetch(fetchRequest) }
        catch { fatalError("Tasks fetch failed.") }
        
        return items
    }
    

    func search(text: String?, categories: [Category], priorities: [Priority], sortType: SortType?, showTasksEmptyPriorities: Bool, showTasksEmptyCategories: Bool, showCompletedTasks: Bool, showTasksWithoutDate: Bool) -> [Task] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()       // объект-контейнер для выборки данных
        
        var predicates = [NSPredicate]()
        
        if let text = text {
            // упрощенная запись предиката (без массива параметров и отдельной переменной для sql)
            predicates.append(NSPredicate(format: "name CONTAINS[c] %@", text))
        }
        
        if !categoryDAO.items.isEmpty {
            if categories.isEmpty {
                if showTasksEmptyCategories { predicates.append(NSPredicate(format: "(NOT (category in %@) or category == nil)", categoryDAO.items)) }
                else { predicates.append(NSPredicate(format: "(NOT (category in %@) and category == nil)", categoryDAO.items)) }
            } else {
                if showTasksEmptyCategories { predicates.append(NSPredicate(format: "(category in %@ or category == nil)", categories)) }
                else { predicates.append(NSPredicate(format: "(category in %@ and category != nil)", categories)) }
            }
        }
        
        if !priorityDAO.items.isEmpty {
            if priorities.isEmpty {
                if showTasksEmptyPriorities { predicates.append(NSPredicate(format: "(NOT (priority in %@) or priority == nil)", priorityDAO.items)) }
                else { predicates.append(NSPredicate(format: "(NOT (priority in %@) and priority == nil)", priorityDAO.items)) }
            } else {
                if showTasksEmptyPriorities { predicates.append(NSPredicate(format: "(priority in %@ or priority == nil)", priorities)) }
                else { predicates.append(NSPredicate(format: "(priority in %@ and priority != nil)", priorities)) }
            }
        }
        
//        if !showTasksEmptyCategories { predicates.append(NSPredicate(format: "category in %@", categories)) }
//        else { predicates.append(NSPredicate(format: "category in %@ or category = nil", categories)) }
        
        if !showTasksEmptyPriorities { predicates.append(NSPredicate(format: "priority != nil")) }
        if !showCompletedTasks { predicates.append(NSPredicate(format: "completed != true")) }
        if !showTasksWithoutDate { predicates.append(NSPredicate(format: "deadline != nil")) }

        let allPredicates = NSCompoundPredicate(type: .and, subpredicates: predicates)

        
        fetchRequest.predicate = allPredicates      //добавляем предикат в контейнер запроса
        
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
