//
//  CrudExtension.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 31/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Crud {
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func save() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
}
