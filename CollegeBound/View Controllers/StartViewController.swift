import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 15
        registerButton.layer.cornerRadius = 15
        registerButton.layer.borderWidth = 3
        registerButton.layer.borderColor = CGColor(srgbRed: 255, green: 255, blue: 255, alpha: 1)
        
        let background = UIImage(named: "books.png")
        
        mainView.setBackgroundImage(image: background)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
}
