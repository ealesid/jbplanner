import Foundation


// поиск задач с учетом фильтрации
protocol TaskSearchDAO: Crud {
    func search(
            text: String?,
            sortType: SortType?,
            showTasksEmptyPriorities: Bool,
            showTasksEmptyCategories: Bool,
            showCompletedTasks: Bool,
            showTasksWithoutDate: Bool
        ) -> [Item]
}
