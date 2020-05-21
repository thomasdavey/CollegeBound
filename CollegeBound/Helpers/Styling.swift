import Foundation
import UIKit

class Styling {
    static func authTextField(textField: UITextField) {
        textField.layer.cornerRadius = 15
        textField.layer.masksToBounds = true
        textField.addDoneButtonOnKeyboard()
    }
    static func authButton(button: UIButton) {
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = false
    }
}
