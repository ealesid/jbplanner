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

class DictionaryController<T:DictionaryDao>: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    var dictTableView: UITableView!     // ссылка на компонент
    var buttonSelectDeselectAll: UIButton!
    
    var dao: T!     // DAO для работы с БД
    
    var currentCheckedIndexPath: IndexPath!     // индекс последнего/текущего выделенного элемента
    
    var selectedItem: T.Item!       // текущий выбранный элемент
    
    var delegate: ActionResultDelegate!     // для передачи выбранного элемента обратно в контроллер
    
    var searchController: UISearchController!
    
    var searchBarText: String!
    
    var searchBar: UISearchBar{ return searchController.searchBar }
    
    var navigationTitle: String!
    
    var changed = false     // были или нет изменения при редактировании, чтобы лишний раз не обновлять  список задач
    
    let sectionList = 0
    
    var showMode: ShowMode!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        searchBar.searchBarStyle = .prominent
    }
    
    
    // MARK: - init
    
    func initNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        if showMode == .select { createSaveCancelButtons(save: #selector(tapSave), cancel: #selector(tapCancel)) }
        else if showMode == .edit { createAddCloseButtons(add: #selector(tapAdd), close: #selector(tapClose)) }
        
        self.title = navigationTitle
    }
    
    
    // MARK: tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dao.items.count
    }
    
    // удаление строки
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { deleteItem(indexPath) }
        else if editingStyle == .insert {}
    }
    
    // выделяет элемент в списке
    func checkItem(_ indexPath: IndexPath) {
                
        let item = dao.items[indexPath.row]
        
        switch showMode {
        case .select?:
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
            
            searchController.isActive = false       // автоматически закрывать поисковое окно, если пользователь выбрал значение

        case .edit?:
            item.checked = !item.checked
            updateItem(item)
            changed = true
            
        default: fatalError("Enum error")
        }
        
        updateSelectDeselectButton()
    }
    
    func selectDeselectItems() {
        if dao.checkedItems().count > 0 { dao.items.map(){$0.checked = false} }
        else { dao.items.map(){$0.checked = true} }
        
        dictTableView.reloadSections([sectionList], with: .none)
        updateSelectDeselectButton()
        changed = true
    }
    
    func updateSelectDeselectButton() {
        
        if showMode == .select { return }
        
        let newTitle: String
        
        if dao.checkedItems().count > 0 { newTitle = "Clear" } else { newTitle = "All" }
        
        if self.buttonSelectDeselectAll.title(for: .normal) != newTitle { buttonSelectDeselectAll.setTitle(newTitle, for: .normal) }
        
        var enabled: Bool
        
        if dao.items.count > 1 { enabled = true } else { enabled = false }
        
        buttonSelectDeselectAll.isEnabled = enabled
        
        if !enabled { return }
    }
    
    
    // MARK: dao
    
    override func cancel() { closeController() }
    
    func save() {
        cancel()
        delegate?.done(source: self, data: selectedItem)        // уведомить делегата и передать выбранное значение
    }
    
    func updateItem(_ item: T.Item) {
        if let selectedIndexPath = dictTableView.indexPathForSelectedRow {
            dao.addOrUpdate(item)
            dictTableView.reloadRows(at: [selectedIndexPath], with: .none)
        }
    }
    
    func deleteItem(_ indexPath: IndexPath) {
        dao.delete(dao.items[indexPath.row])
        dao.items.remove(at: indexPath.row)
        
        dictTableView.deleteRows(at: [indexPath], with: .left)
//        if dao.items.count == 0 { dictTableView.deleteSections([sectionList], with: .left) }
//        else { dictTableView.deleteRows(at: [indexPath], with: .left) }
        
        changed = true
        
        updateSelectDeselectButton()
    }
    
    func addItem(_ item: T.Item) {
        dao.addOrUpdate(item)
        
        let indexPath = IndexPath(row: dao.items.count-1, section: sectionList)
        dictTableView.insertRows(at: [indexPath], with: .top)
        
        updateSelectDeselectButton()

//        if dao.items.count == 1 { dictTableView.insertSections([sectionList], with: .top) }
//        else {
//            let indexPath = IndexPath(row: dao.items.count-1, section: sectionList)
//            dictTableView.insertRows(at: [indexPath], with: .top)
//        }
    }
    
    
    // MARK: - selectors
    
    @objc func tapClose() { performSegue(withIdentifier: "updateTaskCategories", sender: self) }
    
    @objc func tapAdd() { addItemAction() }
    
    @objc func tapSave() { save() }
    
    @objc func tapCancel() { cancel() }
    
    
    // MARK: search
    
    //добавление search bar к таблице
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)     // searchResultsController: nil - т.к. результаты сразу будут отображаться в этом же view
        
        searchController.dimsBackgroundDuringPresentation = false       // затемнять/не затемнять фон при  поиске (при затемнении не доступен выбор найденных записей)
        
        definesPresentationContext = true       // для правильного отображеия внутри таблицы
        
        searchController.searchBar.placeholder = "Type to start search"
        searchController.searchBar.backgroundColor = .white
        
        // обработка действий поиска и работа с search bar в этом же классе
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        // не показывать сразу segmented controls для сортировки результата из-за бага, когда компоненты налезают друг на друга
        searchBar.showsScopeBar = false
        
        // не работает (баг?)
        searchBar.showsCancelButton = false
        searchBar.setShowsCancelButton(false, animated: false)
        
        searchBar.searchBarStyle = .minimal
        
        searchController.hidesNavigationBarDuringPresentation = true    // закрытие navigation bar компонентом поиска
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            dictTableView.tableHeaderView = searchBar
        }
    }
    
    
    // MARK: - Have to be implemented
    
    // получение всех объектов с сортировкой
    func getAll() -> [T.Item] { fatalError("Not implemented!") }
    
    // поиск объектов с сортировкой
    func search(_ text: String) -> [T.Item] { fatalError("Not implemented!") }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { fatalError("Not implemented!") }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { fatalError("Not implemented!") }
    
    func addItemAction() { fatalError("not implemented") }

    // при активации текстового окна - записываем последний поисковый текст
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = searchBarText
        return true
    }
    
    // каждое изменение текста
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchBar.placeholder = "Type to start search"
        }
    }
    
    // нажимаем на кнопку Cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarText = ""
        getAll()
        dictTableView.reloadData()
        searchBar.placeholder = "Type to start search"
    }
    
    // поиск по каждой букве при наборе
    func updateSearchResults(for searchController: UISearchController) {
        if !(searchBar.text?.isEmpty)! {
            searchBarText = searchBar.text!
            search(searchBarText)
            dictTableView.reloadData()
            currentCheckedIndexPath = nil       // чтобы не было двойного выделения значений
            searchBar.placeholder = searchBarText       // сохраняем текст поиска для отображения, если окно поиска будет не активным
        }
    }

}


enum ShowMode {
    case edit
    case select
}
