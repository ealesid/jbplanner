import UIKit

class FiltersController: UITableViewController {
    
    // номер секции с фильтрами
    let filtersSection = 0

    @IBOutlet weak var switchEmptyPriorities: UISwitch!
    @IBOutlet weak var switchEmptyCategories: UISwitch!
    @IBOutlet weak var switchEmptyDates: UISwitch!
    @IBOutlet weak var switchCompleted: UISwitch!
    
    // изменялись ли настройки фильтров
    var changed: Bool { return
        switchEmptyCategories.isOn != switchEmptyCategoriesInitValue ||
        switchEmptyPriorities.isOn != switchEmptyPrioritiesInitValue ||
        switchCompleted.isOn != switchCompletedInitValue ||
        switchEmptyDates.isOn != switchEmptyDatesInitValue
    }
    
    // считываем начальные значения в переменные
    var switchEmptyPrioritiesInitValue = PrefsManager.current.showEmptyPriorities
    var switchEmptyCategoriesInitValue = PrefsManager.current.showEmptyCategories
    var switchCompletedInitValue = PrefsManager.current.showCompletedTasks
    var switchEmptyDatesInitValue = PrefsManager.current.showTasksWithoutDate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // считываем из настроек начальные значения
        switchEmptyCategories.isOn = switchEmptyCategoriesInitValue
        switchEmptyPriorities.isOn = switchEmptyPrioritiesInitValue
        switchEmptyDates.isOn = switchEmptyDatesInitValue
        switchCompleted.isOn = switchCompletedInitValue
    }

    
    // MARK: - Actions
    
    @IBAction func switchedWithoutPriorities(_ sender: UISwitch) { PrefsManager.current.showEmptyPriorities = sender.isOn }
    
    @IBAction func switchedWithoutCategories(_ sender: UISwitch) { PrefsManager.current.showEmptyCategories = sender.isOn }
    
    @IBAction func switchedWithoutDates(_ sender: UISwitch) { PrefsManager.current.showEmptyPriorities = sender.isOn }
    
    @IBAction func switchedCompleted(_ sender: UISwitch) { PrefsManager.current.showCompletedTasks = sender.isOn }
}
