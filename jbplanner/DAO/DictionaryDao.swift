import Foundation
import CoreData


// справочные значения с возможностью выделения элементов
protocol DictionaryDao: Crud where Item: Checkable {
    func checkedItems() -> [Item]
}


extension DictionaryDao {
//    func checkedItems() -> [Item] { return getAll().filter() {$0.checked == true} }
    
    func checkedItems() -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest() as! NSFetchRequest<Self.Item>
        
        let predicate = NSPredicate(format: "checked = true")
        
        fetchRequest.predicate = predicate
        
        var itemsTemp: [Item]
        
        do { itemsTemp = try context.fetch(fetchRequest) }
        catch {fatalError("Fetch failed") }
        
        return itemsTemp
    }
}
