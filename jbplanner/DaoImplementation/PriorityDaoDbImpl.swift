//
//  CategoryDaoDbImpl.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 31/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation
import CoreData

class PriorityDaoDbImpl: Crud {
    
    static let current = PriorityDaoDbImpl()
    private init() {}
    
    var items: [Priority]!
    
    func addOrUpdate(_ priority: Priority) {
        if !items.contains(priority) {
            items.append(priority)
        }
        
        save()
    }
    
    func getAll() -> [Priority] {
        let fetchrequest: NSFetchRequest<Priority> = Priority.fetchRequest()
        
        do {
            items = try context.fetch(fetchrequest)
        } catch {
            fatalError("Priorities fetch failed.")
        }
        
        return items
    }
    
    func delete(_ priority: Priority) {
        context.delete(priority)
        save()
    }
}
