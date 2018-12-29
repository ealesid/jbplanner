//
//  DateExtension.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 29/12/2018.
//  Copyright © 2018 Aleksey Sidorov. All rights reserved.
//

import Foundation

extension Date {
    
    // сегодня
    var today: Date {
        return rewindDays(0)
    }
    
    // получить новую дату от текущей путем прибавления дней
    func rewindDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    // разница между двумя датами в днях
    func offsetFrom(date: Date) -> Int {
        let calendar = Calendar.current
        
        // посчитать разницу между днями без учета разницы в часах
        let startOfCurrentDate = calendar.startOfDay(for: date)
        let startOfOtherDay = calendar.startOfDay(for: self)
        
        return calendar.dateComponents([.day], from: startOfCurrentDate, to: startOfOtherDay).day!
    }
}
