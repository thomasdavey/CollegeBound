import Foundation
import UIKit

class Utilities {
    static func loadingOverlay(message: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        
        return alert
    }
    
    static func checkEmpty(textField: UITextField) -> Bool {
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}
