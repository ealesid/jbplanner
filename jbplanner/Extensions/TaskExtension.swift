//
//  TaskExtension.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 29/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation

extension Task {
    
    // разница между датами в днях
    func daysLeft() -> Int! {
        if self.deadline == nil {
            return nil
        }
        
        return (self.deadline?.offsetFrom(date: Date().today))!
    }
}
