import Foundation


// поиск задач с учетом фильтрации
protocol TaskSearchDAO: Crud {
    
    associatedtype CategoryItem: Category   // любая реализация Category
    
    func search(
            text: String?,
            categories: [CategoryItem],
            sortType: SortType?,
            showTasksEmptyPriorities: Bool,
            showTasksEmptyCategories: Bool,
            showCompletedTasks: Bool,
            showTasksWithoutDate: Bool
        ) -> [Item]
}
