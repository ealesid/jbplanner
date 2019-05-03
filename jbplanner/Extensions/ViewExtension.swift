import Foundation
import UIKit


extension UILabel {
    func roundLabel() {
        self.layer.cornerRadius = 12
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.textAlignment = .center
        self.textColor = UIColor.darkGray
    }
}
