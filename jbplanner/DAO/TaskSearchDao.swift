import Foundation


// поиск задач с учетом фильтрации
protocol TaskSearchDAO: Crud {
    
    associatedtype CategoryItem: Category   // любая реализация Category
    associatedtype PriorityItem: Priority   // любая реализация Category

    func search(
            text: String?,
            categories: [CategoryItem],
            priorities: [Priority],
            sortType: SortType?,
            showTasksEmptyPriorities: Bool,
            showTasksEmptyCategories: Bool,
            showCompletedTasks: Bool,
            showTasksWithoutDate: Bool
        ) -> [Item]
}
