import UIKit

import GCCalendar

class DatetimePickerController: UIViewController, GCCalendarViewDelegate {

    @IBOutlet weak var calendarView: GCCalendarView!
    @IBOutlet weak var labelMonthName: UILabel!
    
    var delegate: ActionResultDelegate!    // для возврата выбранной даты
    var initDeadline: Date!                 // начнальная дата
    var selectedDeadline: Date!             // выбранная (измененная) дата
    var dateFormatter: DateFormatter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter = createDateFormatter()
        
        calendarView.delegate = self        // обрабатываем действия календаря в этом класе
        calendarView.displayMode = .month
        
        // если у задачи была дата - ее нужно показать в календаре
        if initDeadline != nil { calendarView.select(date: initDeadline) }

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - CGCalendarViewDelegate
    
    func calendarView(_ calendarView: GCCalendarView, didSelectDate date: Date, inCalendar calendar: Calendar) {
        dateFormatter.dateFormat = "LLLL yyyy"      // для отображения внизу календаря
//        dateFormatter.calendar = calendar           // раньще было обязательно, теперь можно закомментировать
        labelMonthName.text = dateFormatter.string(from: date).capitalized      // формат вывода даты
        selectedDeadline = date                     // сохраняем выбранную дату
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    
    @IBAction func tapCancel(_ sender: UIButton) {
        closeController()
    }
    
    @IBAction func tapToday(_ sender: UIButton) {
        calendarView.today()
    }
    
    @IBAction func tapSave(_ sender: UIButton) {
        closeController()
        delegate.done(source: self, data: selectedDeadline)
    }
    
}
