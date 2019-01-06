//
//  CategoryDaoDbImpl.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 31/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation
import CoreData

class CategoryDaoDbImpl: Crud {
    var items: [Category]!
    
    static let current = CategoryDaoDbImpl()
    private init() {
        items = getAll()
    }
    
    func addOrUpdate(_ category: Category) {
        if !items.contains(category) {
            items.append(category)
        }
        
        save()
    }
    
    func getAll() -> [Category] {
        let fetchrequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            items = try context.fetch(fetchrequest)
        } catch {
            fatalError("Categories fetch failed.")
        }
        
        return items
    }
    
    func delete(_ category: Category) {
        context.delete(category)
        save()
    }
}
