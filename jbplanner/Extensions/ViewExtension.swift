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


extension UITextView {
    
    func findUrl(sender: UITapGestureRecognizer) -> Bool {
        let textView = self
        let tapLocation = sender.location(in: textView)
        let textPosition = textView.closestPosition(to: tapLocation)
        
        let attr: NSDictionary = textView.textStyling(at: textPosition!, in: UITextStorageDirection.forward)! as NSDictionary
        
        if let url: NSURL = attr[NSAttributedString.Key.link] as? NSURL {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            } else { UIApplication.shared.open(url as URL) }
            
            return true
        }
        
        return false
    }
}
