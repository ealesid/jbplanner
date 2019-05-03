import Foundation
import CoreData


class CategoryDaoDbImpl: DictionaryDao, CommonSearchDAO {

    typealias Item = Category
    typealias SortType = CategorySortType
    
    var items: [Item]!
    
    static let current = CategoryDaoDbImpl()
    private init() { getAll(sortType: CategorySortType.name) }


    // MARK: - dao
    
    func getAll(sortType: SortType?) -> [Category] {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        // добавляем поле для сортировки
        if let sortType = sortType {
            fetchRequest.sortDescriptors = [sortType.getDescriptor(sortType)]
        }

        do {
            items = try context.fetch(fetchRequest)
        } catch {
            fatalError("Categories fetch failed.")
        }
        
        return items
    }
    
    
    func search(text: String, sortType: SortType?) -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", text)
        
        // добавляем поле для сортировки
        if let sortType = sortType { fetchRequest.sortDescriptors = [sortType.getDescriptor(sortType)] }

        do { items = try context.fetch(fetchRequest) }
        catch { fatalError("Categories fetch failed") }
        
        return items
    }
}


// возможные поля для сортировки списка категорий
enum CategorySortType: Int {
    case name = 0
    
    // получить объект сортировки для добавления в fetchRequest
    func getDescriptor(_ sortType: CategorySortType) -> NSSortDescriptor {
        switch sortType {
        case .name:
            return NSSortDescriptor(key: #keyPath(Category.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        }
    }
}
