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
    
    // диалоговое окно для подтверждения действия
    func confirmAction(text: String, actionClosure: @escaping () -> Void) {
        let dialogMessage = UIAlertController(title: "Confirmation", message: text, preferredStyle: .actionSheet)   // объект диалогового окна
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in actionClosure() })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in actionClosure() })
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        present(dialogMessage, animated: true, completion: nil)
    }
    
    // add Save and Cancel buttons
    func createSaveCancelButtons(save: Selector, cancel: Selector = #selector(cancel)) {
        let buttonCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: cancel)
        navigationItem.leftBarButtonItem = buttonCancel
        
        let buttonSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: save)
        navigationItem.rightBarButtonItem = buttonSave
    }
    
    // add Add and Close buttons
    func createAddCloseButtons(add: Selector, close: Selector = #selector(cancel)) {
        let buttonClose = UIBarButtonItem()
        buttonClose.target = self
        buttonClose.action = close
        buttonClose.title = "Close"
        navigationItem.leftBarButtonItem = buttonClose
        
        let buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: add)
        navigationItem.rightBarButtonItem = buttonAdd
    }
    
    @objc func cancel() { closeController() }
    
    // проверяем, пустое ли значение, с учетом удаления пробелов и переноса строки
    func isEmptyTrim(_ str: String?) -> Bool {
        if let value = str?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty {
            return false    // значит - не пусто
        } else {
            return true
        }
    }
    
    func showDialog(title: String, message: String, initValue: String = "", actionClosure: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?[0].clearButtonMode = .whileEditing
            alert.textFields?[0].text = initValue
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in actionClosure(alert.textFields?[0].text ?? "") }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // message - No data
    func createNoDataView(_ text: String) -> UILabel {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textColor = UIColor.darkGray
        messageLabel.textAlignment = .center
        messageLabel.text = text
        
        return messageLabel
    }
    
    // обновляет фон для таблицы, если нет данных
    func updateTableBackground(_ tableView: UITableView, count: Int) {
        if count > 0 {
            tableView.separatorColor = UIColor.gray
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none
            tableView.backgroundView = createNoDataView("No data")
        }
    }
    
    // скрыть клавиатуру
    func hideKeyboardWhenTypingAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() { view.endEditing(true) }
}
