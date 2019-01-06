//
//  ActionResultDelegate.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 06/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import Foundation
import UIKit

// уведомление другого контроллера о саоем действии и передача объекта (если необходимо)
protocol ActionResultDelegate {
    func done(source: UIViewController, data: Any?)
    func cancel(source: UIViewController, data: Any?)
}

//реализация по-умолчанию для интерфейса
extension ActionResultDelegate{
    
    func done(source: UIViewController, data: Any?) {
        fatalError("Not Implemented")
    }

    func cancel(source: UIViewController, data: Any?) {
        fatalError("Not Implemented")
    }
}
