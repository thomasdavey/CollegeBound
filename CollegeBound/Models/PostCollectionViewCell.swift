import UIKit
import Kingfisher

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    
    func setPost(post: Post) {
        postImage.kf.indicatorType = .activity
        postImage.kf.setImage(with: URL(string: post.imageURL), options: [
            .transition(.fade(1))
        ])
        postImage.contentMode = .scaleAspectFill
    }
}
