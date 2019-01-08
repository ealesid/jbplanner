//
//  TaskDaoDbImpl.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 31/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation
import CoreData

class TaskDaoDbImpl: Crud {
   
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
        let fetchrequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            items = try context.fetch(fetchrequest)
        } catch {
            fatalError("Tasks fetch failed.")
        }
        
        return items
    }
    
    func delete(_ task: Task) {
        context.delete(task)
        save()
    }
}
