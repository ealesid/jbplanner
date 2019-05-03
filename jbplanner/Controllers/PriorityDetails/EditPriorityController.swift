import Foundation
import UIKit
import ChromaColorPicker


class EditPriorityController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textPriorityName: UITextField!
    @IBOutlet weak var colorPicker: ChromaColorPicker!
    
    var priority: Priority?
    var navigationTitle: String!
    var delegate: ActionResultDelegate!
    var priorityDAO = PriorityDaoDbImpl.current
    var selectedColor: UIColor!
//    var actionClosure: ((Priority) ->Void)      // замыкание после сохранения
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        initColorPicker()
        initTextField()
        initNavBar()
        hideKeyboardWhenTypingAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: tableView
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Priority name"
        case 1: return "Select color"
        default: return ""
        }
    }
    
    
    // MARK: init
    
    func initTextField() {
        textPriorityName.delegate = self
        if isEmptyTrim(textPriorityName.text) { textPriorityName.becomeFirstResponder() }
    }
    
    func initNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        createSaveCancelButtons(save: #selector(tapSave))
        self.title = navigationTitle
    }
    
    func initColorPicker() {
        if let priority = priority {
            textPriorityName.text = priority.name
            
            if let color = priority.color { colorPicker.adjustToColor(color as! UIColor) }
        }
        
        colorPicker.hexLabel.isHidden = true
        colorPicker.supportsShadesOfGray = true
        colorPicker.padding = 10
    }
    
    
    // MARK: IB
    
    @objc func tapSave() {
        if priority == nil {
            priority = Priority(context: priorityDAO.context)
            priority?.index = Int32(priorityDAO.items.count+1)
        }
        
        if let priority = priority {
            priority.color = colorPicker.currentColor
            if isEmptyTrim(textPriorityName.text) { priority.name = "New priority" }
            else { priority.name = textPriorityName.text }
            
            delegate.done(source: self, data: priority)     // возвращаем результат обратно в контроллер
        }
        
        closeController()
    }
}
