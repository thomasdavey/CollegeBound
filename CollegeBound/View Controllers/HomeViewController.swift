import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post] = []
    var refreshControl = UIRefreshControl()
    var curretStamp = Double(NSDate().timeIntervalSince1970)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func fetchPosts() {
        let db = Firestore.firestore()
        var tempTime = 0.0
        
        self.tableView.reloadData()
        db.collection("posts")
            .whereField("timestamp", isLessThan: curretStamp)
            .order(by: "timestamp", descending: true)
            .getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    let tempPost = Post(imageURL: document["imageURL"] as! String,
                                        title: document["title"] as! String,
                                        price: document["price"] as! Int,
                                        description: document["description"] as! String,
                                        uid: document["uid"] as! String)
                    
                    self.posts.append(tempPost)
                    
                    tempTime = document["timestamp"] as! Double
                }
                self.curretStamp = tempTime - 1
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        curretStamp = Double(NSDate().timeIntervalSince1970)
        posts.removeAll()
        fetchPosts()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTableViewCell
        
        cell.setPost(post: post)
        
        if cell.uid != Auth.auth().currentUser!.uid {
            let tapProfile = myRecogniser(target: self, action: #selector(profileImageTapped))
            tapProfile.title = cell.uid!
            cell.postProfilePicture.addGestureRecognizer(tapProfile)
            cell.postProfilePicture.isUserInteractionEnabled = true
        }
        
        return cell
    }
    
    @objc func profileImageTapped(_ sender: myRecogniser) {
        profileSender = sender.title
        
        self.performSegue(withIdentifier: "toProfile", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    var tappedPost = Post(imageURL: "", title: "", price: 0, description: "", uid: "")
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedPost = posts[indexPath.row]
        
        self.performSegue(withIdentifier: "viewPost", sender: nil)
    }
    
    var profileSender = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewPost" {
            if let destinationVC = segue.destination as? ViewPostViewController {
                destinationVC.post = tappedPost
            }
        }
        if segue.identifier == "toProfile" {
            if let destinationVC = segue.destination as? ProfileViewController {
                destinationVC.uid = profileSender
            }
        }
    }
}

class myRecogniser: UITapGestureRecognizer {
    var title = ""
}
