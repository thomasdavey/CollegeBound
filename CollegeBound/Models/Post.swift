import Foundation
import UIKit
import Firebase

class Post {
    
    var imageURL: String
    var title: String
    var price: Int
    var description: String
    var uid: String
    
    init(imageURL: String, title: String, price: Int, description: String, uid: String) {
        self.imageURL = imageURL
        self.title = title
        self.price = price
        self.description = description
        self.uid = uid
    }
}
