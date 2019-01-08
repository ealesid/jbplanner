//
//  DictionaryController.swift
//  jbplanner
//
//  Created by Aleksey Sidorov on 06/01/2019.
//  Copyright © 2019 Aleksey Sidorov. All rights reserved.
//

import Foundation
import UIKit

// Общий класс для контроллеров по работе со справочными значениями (категории, приоритеты)

class DictionaryController<T:Crud>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dictTableView: UITableView!     // ссылка на компонент
    
    var dao: T!     // DAO для работы с БД
    
    var currentCheckedIndexPath: IndexPath!     // индекс последнего/текущего выделенного элемента
    
    var selectedItem: T.Item!       // текущий выбранный элемент
    
    var delegate: ActionResultDelegate!     // для передачи выбранного элемента обратно в контроллер

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dao.items.count
    }
    
    // должен реализовываться в дочернем классе
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Not implemented!")
    }
    
    // выделяет элемент в списке
    func checkItem(_ sender: UIView) {
        
        // определение строки по координатам нажатия
        let viewPosition = sender.convert(CGPoint.zero, to: dictTableView)
        let indexPath = dictTableView.indexPathForRow(at: viewPosition)!
        
        let item = dao.items[indexPath.row]
        
        if indexPath != currentCheckedIndexPath {       // если строка не была выделена до этого
            selectedItem = item
            
            if let currentCheckedIndexPath = currentCheckedIndexPath {      // снимаем выделение для предыдущей выбранной строки
                dictTableView.reloadRows(at: [currentCheckedIndexPath], with: .none)        // обновляем предыдущую выбранную строку
            }
            
            currentCheckedIndexPath = indexPath     // запоминаем новый выбранный индекс
            
        } else {    // если строка уже была выделена - снимаем выделение
            selectedItem = nil
            currentCheckedIndexPath = nil
        }
        
        // обновляем вид нажатой строки
        dictTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    // MARK: dao
    
    func cancel() {
        navigationController?.popViewController(animated: true)     // закрыть контроллер и удалить из navigation stack
    }
    
    func save() {
        cancel()
        delegate?.done(source: self, data: selectedItem)        // уведомить делегата и передать выбранное значение
    }

}
