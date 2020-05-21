import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Styling.authTextField(textField: firstNameTextField)
        Styling.authTextField(textField: lastNameTextField)
        Styling.authTextField(textField: emailTextField)
        Styling.authTextField(textField: passwordTextField)
        Styling.authButton(button: registerButton)
        
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
        if Utilities.checkEmpty(textField: firstNameTextField) {
            return "First name cannot be left blank."
        }
        if Utilities.checkEmpty(textField: lastNameTextField) {
            return "Last name cannot be left blank."
        }
        if Utilities.checkEmpty(textField: emailTextField) {
            return "Email address cannot be left blank."
        }
        if Utilities.checkEmpty(textField: passwordTextField) {
            return "Password cannot be left blank."
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if validatePassword(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters long and contains at least one number and one uppercase letter."
        }
        
        return nil
    }
    
    func validatePassword(_ password: String) -> Bool {
        let validate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[A-Za-z0-9]{8,}")
        return validate.evaluate(with: password)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    print(error!)
                    self.showError("Error creating user.")
                } else {
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: [
                        "firstname":firstName,
                        "lastname":lastName,
                        "uid":result!.user.uid
                    ]) { (err) in
                        if err != nil {
                            self.showError("Error saving user data.")
                        }
                    }
                    
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
