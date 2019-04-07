import Foundation
import UIKit


extension UIViewController {
    
    // создает объект для форматирования дат
    func createDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }
    
    // закрывает контроллер в зависимости от того, как его открыли (модально или через NavigationController)
    func closeController() {
        if presentingViewController is UINavigationController {     // если открыли без использования стека
            dismiss(animated: true, completion: nil)
        } else if let controller = navigationController {      // если открыли из NavigationController
            controller.popViewController(animated: true)
        } else {
            fatalError("Can't close controller!")
        }
    }
    
    // определяет текст для разницы в днях и стиль для label
    func handleDaysDiff(_ diff: Int?, label: UILabel) {
        
        label.textColor = .lightGray        // цвет по-умолчанию
        
        var text: String = ""
        
        if let diff = diff {
            switch diff {
            case 0:
                text = "Today"      // TODO: Localization
            case 1:
                text = "Tomorrow"
            case 1...:
                text = "\(diff)d"
            case ..<0:
                text = "\(diff)d"
                label.textColor = .red
            default:
                text = ""
            }
        }
        
        label.text = text 
    }
}
