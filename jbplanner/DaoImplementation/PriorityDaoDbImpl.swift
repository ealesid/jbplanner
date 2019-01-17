//
//  CategoryDaoDbImpl.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 31/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation
import CoreData

class PriorityDaoDbImpl: CommonSearchDAO {
    
    static let current = PriorityDaoDbImpl()
    private init() {
//        items = getAll()
    }
    
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
    
    func search(text: String) -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        var params = [Any]()
        var sql = "name CONTAINS[c] %@"
        params.append(text)
        var predicate = NSPredicate(format: sql, argumentArray: params)
        fetchRequest.predicate = predicate
        
        do {
            items = try context.fetch(fetchRequest)
        } catch {
            fatalError("Priorities fetching failed")
        }
        
        return items
    }

}
