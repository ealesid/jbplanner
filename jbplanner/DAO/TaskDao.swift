//
//  TaskDao.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 12/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import Foundation

protocol TaskDao: Crud {
    func search(text: String) -> [Item]
}
