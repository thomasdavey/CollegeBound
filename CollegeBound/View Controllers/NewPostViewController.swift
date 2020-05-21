import UIKit
import Firebase
import FirebaseStorage
import CoreLocation

class NewPostViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postPrice: UITextField!
    @IBOutlet weak var postDescription: UITextView!
    
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postImage.image = image
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(postImageTapped))
        postImage.addGestureRecognizer(tap)
        
        postImage.isUserInteractionEnabled = true
        
        postTitle.addDoneButtonOnKeyboard()
        postPrice.addDoneButtonOnKeyboard()
    }
    
    @objc func postImageTapped(_ sender: Any) {
        print("Tapped!")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        postImage.image = (info[UIImagePickerController.InfoKey.editedImage] as! UIImage)
        image = postImage.image!
    }
    
    @IBAction func exitView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func validateFields() -> String? {
        if Utilities.checkEmpty(textField: postTitle) {
            return "Title cannot be left blank."
        }
        if Utilities.checkEmpty(textField: postPrice) {
            return "Price cannot be left blank."
        }
        if Int(postPrice.text!) == nil {
            return "Price needs to be a whole number."
        }
        if image.size.width == 0 {
            return "Click the grey area to add an image to your post!"
        }
        
        return nil
    }
    
    @IBAction func submitPost(_ sender: Any) {
        let db = Firestore.firestore()
        
        if let error = validateFields() {
            let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .cancel, handler: nil)
            
            alertController.addAction(dismissAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        let postingAlert = Utilities.loadingOverlay(message: "Posting...")
        present(postingAlert, animated: true, completion: nil)
    
        let dbRef = db.collection("posts")
        let doc = dbRef.document()
    
        let storageRef = Storage.storage().reference().child(doc.documentID + ".jpeg")
        let uploadData = self.image.jpegData(compressionQuality: 0.5)
        
        doc.setData([
            "title":postTitle.text ?? "",
            "price":Int(postPrice.text ?? "0") ?? 0,
            "description":postDescription.text ?? "",
            "timestamp":NSDate().timeIntervalSince1970,
            "uid": Auth.auth().currentUser!.uid
        ]) { (error) in
            if error != nil {
                print("Error creating post.")
                return
            } else {
                storageRef.putData(uploadData!, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    } else {
                        print(metadata!)
                        storageRef.downloadURL { (url, error) in
                            doc.setData(["imageURL":url?.absoluteString as Any], merge: true)
                        }
                        postingAlert.dismiss(animated: false)
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
}
