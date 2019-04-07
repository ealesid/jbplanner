//
//  Crud.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 31/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation
import CoreData

protocol Crud {
    associatedtype Item: NSManagedObject    // NSManagedObject - чтобы объек можно было записывать в ДБ
    associatedtype SortType                 // Тип сортировки - для каждого объекта свои поля сортировки
    var items:[Item]! {get set}
    func addOrUpdate(_ item: Item)
    func getAll(sortType: SortType?) -> [Item]
    func delete(_ item: Item)
}
