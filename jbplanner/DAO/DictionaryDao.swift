import Foundation


// спрарвочные значения с возможностью выделения элементов
protocol DictionaryDao: Crud where Item: Checkable {
    func checkedItems() -> [Item]
}


extension DictionaryDao {
    public func checkedItems() -> [Item] { return items.filter() {$0.checked == true} }
}
