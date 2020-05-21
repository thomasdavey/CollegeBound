import Foundation
import UIKit

class CustomTabBarController:  UITabBarController, UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var cameraViewController: CameraViewController!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        cameraViewController = CameraViewController()
        
        self.delegate = self

        cameraViewController.tabBarItem.image = UIImage(systemName: "camera")
        
        viewControllers![1] = cameraViewController
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: CameraViewController.self) {
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            print("FINISHED!")
            return false
        }
        return true
    }
    
    var image = UIImage()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        picker.dismiss(animated: true) {
            self.performSegue(withIdentifier: "newPost", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newPost" {
            if let destinationVC = segue.destination as? NewPostViewController {
                destinationVC.image = image
            }
        }
    }
}
