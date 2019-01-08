//
//  AreaTapButton.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 08/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import UIKit

//кнопка с дополнительной областью для нажатия
class AreaTapButton: UIButton {
    
    // область кнопки будет немного больше, чем картинка
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let margin: CGFloat = 10        // доп область вокруг кнопки
        let area = bounds.insetBy(dx: -margin, dy: -margin)     // установка новой границы
        return area.contains(point)
    }
}
