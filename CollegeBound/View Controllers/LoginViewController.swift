import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Styling.authTextField(textField: emailTextField)
        Styling.authTextField(textField: passwordTextField)
        Styling.authButton(button: loginButton)

        mainView.setGradient(colorOne: Constants.Colors.gradientPurple, colorTwo: Constants.Colors.gradientPink, fromPoint: CGPoint(x: 0.2, y: 1), toPoint: CGPoint(x: 0.8, y: 0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    
    func validateFields() -> String? {
        if Utilities.checkEmpty(textField: emailTextField) {
            return "Email address cannot be left blank."
        }
        if Utilities.checkEmpty(textField: passwordTextField) {
            return "Password cannot be left blank."
        }
        
        return nil
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let loginAlert = Utilities.loadingOverlay(message: "Authenticating...")
        
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            present(loginAlert, animated: true, completion: nil)
        
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    print(error!)
                    loginAlert.dismiss(animated: true)
                    self.showError(error!.localizedDescription)
                } else {
                    loginAlert.dismiss(animated: true)
                    self.transitionToHome()
                }
            }
        }
        
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        let entryPoint = storyboard?.instantiateViewController(identifier: "EntryPoint") as? UITabBarController
        
        view.window?.rootViewController = entryPoint
        view.window?.makeKeyAndVisible()
    }
}
