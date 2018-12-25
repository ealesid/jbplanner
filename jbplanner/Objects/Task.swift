//
//  Task.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 25/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation

class Task {
    var name = ""
    var category:String?
    var priority: String?
    var deadLine: Date?
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, category: String) {
        self.name = name
        self.category = category
    }
    
    init(name: String, category: String, deadLine: Date) {
        self.name = name
        self.category = category
        self.deadLine = deadLine
    }
    init(name: String, category: String, priority: String) {
        self.name = name
        self.category = category
        self.priority = priority
    }
    
}
