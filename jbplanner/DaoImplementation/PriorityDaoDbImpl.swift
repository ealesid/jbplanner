//
//  CategoryDaoDbImpl.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 31/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation
import CoreData

class PriorityDaoDbImpl: DictionaryDao, CommonSearchDAO {
    
    typealias Item = Priority
    typealias SortType = PrioritySortType
    
    static let current = PriorityDaoDbImpl()
    private init() { getAll(sortType: PrioritySortType.index) }
    
    var items: [Priority]!
    

    // MARK: - dao
    
    func getAll(sortType: SortType?) -> [Priority] {
        let fetchRequest: NSFetchRequest<Priority> = Priority.fetchRequest()
        
        // добавляем поле для сортировки
        if let sortType = sortType { fetchRequest.sortDescriptors = [sortType.getDescriptor(sortType)] }

        
        do { items = try context.fetch(fetchRequest) }
        catch { fatalError("Priorities fetch failed.") }
        
        return items
    }
    

    func search(text: String, sortType: SortType?) -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", text)
        
        // добавляем поле для сортировки
        if let sortType = sortType { fetchRequest.sortDescriptors = [sortType.getDescriptor(sortType)] }

        do { items = try context.fetch(fetchRequest) }
        catch { fatalError("Priorities fetching failed") }
        
        return items
    }
    
    
    //    MARK: util
    
    func updateIndexes() {
        for (index, item) in items.enumerated() { item.index = Int32(index) }
        save()
        items = getAll(sortType: .index)
    }
}


// возможные поля для сортировки списка приоритетов
enum PrioritySortType: Int {
    case index = 0
    
    // получить объект сортировки для добавления в fetchRequest
    func getDescriptor(_ sortType: PrioritySortType) -> NSSortDescriptor {
        switch sortType {
        case .index:
            return NSSortDescriptor(key: #keyPath(Priority.index), ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        }
    }
}
