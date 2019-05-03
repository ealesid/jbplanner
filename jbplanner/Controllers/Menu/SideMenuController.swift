import UIKit

class SideMenuController: UITableViewController {
    
    @IBOutlet weak var cellFeedback: UITableViewCell!
    @IBOutlet weak var cellShare: UITableViewCell!
    
    
    let sectionCommon = 0
    let sectionDictionary = 1
    let sectionHelp = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.darkGray        // темный фон для меню
    }
    
    
    // MARK: - tableView
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.tintColor = UIColor.darkGray
        header.textLabel?.textColor = UIColor.lightGray
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.tintColor = UIColor.darkGray
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.isUserInteractionEnabled = false      // защита от двойных нажатий
        
        if tableView.cellForRow(at: indexPath) === cellFeedback {
            let email = "app@support.org"       // TODO: вынести в plist
            if let url = URL(string: "mailto:\(email)") { UIApplication.shared.open(url) }
            
            tableView.isUserInteractionEnabled = true
            
            return
        }
        
        if tableView.cellForRow(at: indexPath) === cellShare {
            let shareController = UIActivityViewController(activityItems: ["Create iOS application from beginning"], applicationActivities: nil)
            shareController.popoverPresentationController?.sourceView = self.view
            present(shareController, animated: true, completion: nil)
            
            tableView.isUserInteractionEnabled = true
            
            return
        }
    }
    
    // заголовки секций
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case sectionCommon:
            return "Common"
        case sectionDictionary:
            return "Dictionary"
        case sectionHelp:
            return "Help"
        default:
            return ""
        }
    }
    
    // высота секций
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    // MARK: - prepare
    
    // открытие нужного контроллера при нажатии на пункт меню
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == nil { return }
        
        switch segue.identifier {
        case "editCategories":
            guard let controller = segue.destination as? CategoryListController else { fatalError("error") }
            controller.showMode = .edit
            controller.navigationTitle = "Edit category"
        case "editPriorities":
            guard let controller = segue.destination as? PriorityListController else { fatalError("error") }
            controller.showMode = .edit
            controller.navigationTitle = "Edit Priorities"
        default:
            return
        }
    }

}
