import Foundation


// класс для работы с настройками приложений
class PrefsManager {
    
    let showCompletedTasksKey = "showCompletedTasks"
    let showEmptyPrioritiesKey = "showEmptyPriorities"
    let showTasksWithoutDateKey = "showTasksWithoutDate"
    let showEmptyCategoriesKey = "showEmptyCategories"
    let sortTypeKey = "sortType"
    
    static let current = PrefsManager()
    
    private init() {
        
        // создать ключи для хранения настроек (только при первом запуске)
        UserDefaults.standard.register(defaults: [showEmptyCategoriesKey : true])
        UserDefaults.standard.register(defaults: [showEmptyPrioritiesKey : true])
        UserDefaults.standard.register(defaults: [showTasksWithoutDateKey : true])
        UserDefaults.standard.register(defaults: [showCompletedTasksKey : true])
        UserDefaults.standard.register(defaults: [sortTypeKey: 0])  // сортировка по имени
    }
    
    
    // MARK: - filter settings

    var showEmptyCategories: Bool {
        get { return UserDefaults.standard.bool(forKey: showEmptyCategoriesKey) }
        set { UserDefaults.standard.set(newValue, forKey: showEmptyCategoriesKey) }
    }

    var showEmptyPriorities: Bool {
        get { return UserDefaults.standard.bool(forKey: showEmptyPrioritiesKey) }
        set { UserDefaults.standard.set(newValue, forKey: showEmptyPrioritiesKey) }
    }

    var showCompletedTasks: Bool {
        get { return UserDefaults.standard.bool(forKey: showCompletedTasksKey) }
        set { UserDefaults.standard.set(newValue, forKey: showCompletedTasksKey) }
    }

    var showTasksWithoutDate: Bool {
        get { return UserDefaults.standard.bool(forKey: showTasksWithoutDateKey) }
        set { UserDefaults.standard.set(newValue, forKey: showTasksWithoutDateKey) }
    }
    
    
    // MARK: - sort setiings
    
    var sortType: Int {
        get { return UserDefaults.standard.integer(forKey: sortTypeKey) }
        set { UserDefaults.standard.set(newValue, forKey: sortTypeKey) }
    }
}
