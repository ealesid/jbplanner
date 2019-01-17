//
//  CommonSearchDAO.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 17/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import Foundation

protocol CommonSearchDAO: Crud {
    func search(text: String) -> [Item]
}
