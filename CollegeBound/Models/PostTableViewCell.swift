import UIKit
import Firebase
import Kingfisher

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postPrice: UILabel!
    @IBOutlet weak var postProfilePicture: UIImageView!
    @IBOutlet weak var postName: UILabel!
    
    var uid: String?
    
    func setPost(post: Post) {
        uid = post.uid
        
        postImage.kf.indicatorType = .activity
        postImage.kf.setImage(with: URL(string: post.imageURL), options: [
            .transition(.fade(1))
        ])
        postImage.contentMode = .scaleAspectFill
        postTitle.text = post.title
        postPrice.text = "£" + String(post.price)
        
        let storageRef = Storage.storage().reference().child(post.uid + ".jpeg")
        
        storageRef.downloadURL { (URL, error) in
            if error != nil {
                print(error!)
            } else {
                self.postProfilePicture.kf.setImage(with: URL!)
            }
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").whereField("uid", isEqualTo: post.uid).getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    let firstname = document["firstname"] as! String
                    let lastname = document["lastname"] as! String
                    self.postName.text = firstname + " " + lastname
                }
            }
        }
    }
}
