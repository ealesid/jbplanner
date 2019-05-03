//
//  Crud.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 31/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation
import CoreData
import UIKit


protocol Crud: class {
    associatedtype Item: NSManagedObject    // NSManagedObject - чтобы объек можно было записывать в ДБ
    associatedtype SortType                 // Тип сортировки - для каждого объекта свои поля сортировки
    var items:[Item]! {get set}
    func addOrUpdate(_ item: Item)
    func add(_ item: Item)
    func update(_ item: Item)
    func getAll() -> [Item]                     // получение всех значений без сортировки
    func getAll(sortType: SortType?) -> [Item]
    func delete(_ item: Item)
}


extension Crud {
    
    // контекст для оаботы с БД
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func save() {
        print("crud save")
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    // MARK: - default implementations
    
    func getAll() -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest() as! NSFetchRequest<Self.Item>
        do { items = try context.fetch(fetchRequest) }
        catch { fatalError("Tasks fetching failed") }
        return items
    }
    
    func delete(_ item: Item) {
        context.delete(item)
        save()
    }

    func addOrUpdate(_ item: Item) {
        if !items.contains(item) { add(item) }
        save()
    }
    
    func add(_ item: Item) {
        items.append(item)
        save()
    }
    
    func update(_ item: Item) { save() }
}
