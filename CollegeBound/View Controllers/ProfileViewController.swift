import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [Post] = []
    var refreshControl = UIRefreshControl()
    var curretStamp = Double(NSDate().timeIntervalSince1970)
    
    var uid: String?
    
    var searchUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        
        if uid == nil {
            searchUID = Auth.auth().currentUser!.uid
        } else {
            searchUID = uid!
        }
        
        db.collection("users").whereField("uid", isEqualTo: searchUID).getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    let firstname = document["firstname"] as! String
                    let lastname = document["lastname"] as! String
                    self.userName.text = firstname + " " + lastname
                }
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.addGestureRecognizer(tap)
        profileImage.isUserInteractionEnabled = true
        
        let storageRef = Storage.storage().reference().child(searchUID + ".jpeg")
        storageRef.downloadURL { (URL, error) in
            if error != nil {
                print(error!)
            } else {
                self.profileImage.kf.setImage(with: URL!)
            }
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        posts.removeAll()
        fetchPosts()
    }
    
    func fetchPosts() {
        let db = Firestore.firestore()
        
        self.collectionView.reloadData()
        
        db.collection("posts").whereField("uid", isEqualTo: searchUID).order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    let tempPost = Post(imageURL: document["imageURL"] as! String,
                                        title: document["title"] as! String,
                                        price: document["price"] as! Int,
                                        description: document["description"] as! String,
                                        uid: document["uid"] as! String)
                    
                    self.posts.append(tempPost)
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        curretStamp = Double(NSDate().timeIntervalSince1970)
        posts.removeAll()
        fetchPosts()
        refreshControl.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ownPostCell", for: indexPath) as! PostCollectionViewCell
        
        cell.setPost(post: post)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (self.collectionView.frame.width / 3) - 1
        
        return CGSize(width: size, height: size)
    }
    
    var tappedPost = Post(imageURL: "", title: "", price: 0, description: "", uid: "")
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tappedPost = posts[indexPath.row]
        
        if searchUID == Auth.auth().currentUser!.uid {
            self.performSegue(withIdentifier: "viewPost2", sender: nil)
        } else {
            self.performSegue(withIdentifier: "viewPost3", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewPost2" || segue.identifier == "viewPost3" {
            if let destinationVC = segue.destination as? ViewPostViewController {
                destinationVC.post = tappedPost
            }
        }
    }
    
    @objc func profileImageTapped(_ sender: Any) {
        print("Tapped!")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    var image = UIImage()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        profileImage.image = (info[UIImagePickerController.InfoKey.editedImage] as! UIImage)
        
        let uploadData = profileImage.image!.jpegData(compressionQuality: 0.5)
        let storageRef = Storage.storage().reference().child(Auth.auth().currentUser!.uid + ".jpeg")
        
        storageRef.putData(uploadData!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!)
                return
            } else {
                print(metadata!)
            }
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        signOutPopup()
    }
    
    func signOutPopup() {
        let alertController = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (UIAlertAction) in
            do {
                try Auth.auth().signOut()
                
                let entryPoint = self.storyboard?.instantiateViewController(identifier: "StartPoint")
                
                self.view.window?.rootViewController = entryPoint
                self.view.window?.makeKeyAndVisible()
            } catch {
                print("Error signing out.")
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
