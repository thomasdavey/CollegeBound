import UIKit
import FirebaseAuth

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var entryPoint = storyboard?.instantiateViewController(identifier: "StartPoint")
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                entryPoint = self.storyboard?.instantiateViewController(identifier: "EntryPoint") as? UITabBarController
                
                self.view.window?.rootViewController = entryPoint
                self.view.window?.makeKeyAndVisible()
            } else {
                self.view.window?.rootViewController = entryPoint
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
