import UIKit


class TaskInfoController: UIViewController {

    @IBOutlet weak var textviewTaskInfo: UITextView!
    
    var taskInfo: String!       // текущий выбранный элемент
    
    var taskInfoShowMode: TaskInfoShowMode!
    
    var navigationTitle: String!
    
    var delegate: ActionResultDelegate!     // для передачи выбранного элемента обратно в контроллер
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = navigationTitle
        
        textviewTaskInfo.text = taskInfo
        
        switch taskInfoShowMode {
        case .readonly?:
            textviewTaskInfo.isEditable = false
            
            let tap: UIGestureRecognizer = UIGestureRecognizer(target: textviewTaskInfo, action: #selector(tapTextView(_:)))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
            
        case .edit?:
            textviewTaskInfo.isEditable = true
            createSaveCancelButtons(save: #selector(tapSave))
            textviewTaskInfo.becomeFirstResponder()
            
        default: return
        }
    }
    

    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        closeController()
    }
    
    @IBAction func tapSave(_ sender: UIBarButtonItem) {
        closeController()
        delegate?.done(source: self, data: textviewTaskInfo.text)
    }
    
    
//    @objc func tapSave() {
//        closeController()
//        delegate?.done(source: self, data: textviewTaskInfo.text)
//    }
    
    @objc func tapTextView(_ sender: UITapGestureRecognizer) {
        textviewTaskInfo.findUrl(sender: sender)
    }
    
    
}


enum TaskInfoShowMode {
    case readonly
    case edit
}
