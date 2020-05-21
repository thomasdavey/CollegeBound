import UIKit
import Firebase

class ViewPostViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postPrice: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    
    var post = Post(imageURL: "", title: "", price: 0, description: "", uid: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postImage.kf.setImage(with: URL(string: post.imageURL), options: [
            .transition(.fade(1))
        ])
        
        postTitle.text = post.title
        postPrice.text = "£" + String(post.price)
        postDescription.text = post.description
        
        navBar.title = post.title
    }
}
