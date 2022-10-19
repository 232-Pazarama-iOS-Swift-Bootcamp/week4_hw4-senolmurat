//
//  ProfileViewController.swift
//  Crypto App
//
//  Created by Murat ŞENOL on 12.10.2022.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: PhotoGridCell.getNibName(), bundle: nil), forCellWithReuseIdentifier: PhotoGridCell.getDescribingIdentifier())
        }
    }
    @IBOutlet weak var bookmarksButton: UIButton!
    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var pencilImageView: UIImageView!
    
    private var favouritesPathList: [String] = []
    private var bookmarksPathList: [String] = []
    private var photoPathList: [String] = []
    private var isFavourites: Bool = true {
        didSet {
            photoPathList = isFavourites ? favouritesPathList : bookmarksPathList
            collectionView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bookmarkGesture = UITapGestureRecognizer(target: self, action:  #selector (self.pencilClicked(_:)))
        self.pencilImageView.addGestureRecognizer(bookmarkGesture)
        FirebaseManager.delegate = self
        
        navigationItem.title = "Profile"
        navigationController?.tabBarItem.image = UIImage(named: "person")
        
        setupUI()
    }
    
    private func setupUI() {
        self.showLoadingIndicator()
        let userRef = FirebaseManager.db.collection("users").document(FirebaseManager.currentAuthUser!.uid)

        userRef.getDocument { (user, error) in
            if let user = user, user.exists {
                self.usernameLabel.text = user.get("username") as! String
                self.favouritesPathList = user.get("favourites") as! [String]
                self.bookmarksPathList = user.get("bookmarks") as! [String]
                self.favouritesAction(self.favouritesButton)
                self.dismissLoadingIndicator()
            } else {
                self.dismissLoadingIndicator()
                print("User does not exist")
            }
        }
    }

    @IBAction func signOutAction(_ sender: UIBarButtonItem) {
        AlertManager.showConfirmation(with: "Are you sure you want to log out ?", in: self) { action in
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
                let viewController = AuthViewController()
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true)
            } catch let signOutError as NSError {
              AlertManager.showInfoAlertBox(for: signOutError, in: self, handler: nil)
              print("Error signing out: %@", signOutError)
            }
        }
    }
    
    
    @IBAction func favouritesAction(_ sender: UIButton) {
        sender.imageView?.image = UIImage(named: "heart.fill")
        bookmarksButton.imageView?.image = UIImage(named: "bookmark")
        isFavourites = true
    }
    @IBAction func bookmarksAction(_ sender: UIButton) {
        sender.imageView?.image = UIImage(named: "bookmark.fill")
        favouritesButton.imageView?.image = UIImage(named: "heart")
        isFavourites = false
    }
    
    @objc func pencilClicked(_ sender:UITapGestureRecognizer) {
        self.showInputDialog(title: "Change Username", subtitle: "Please enter your new username", actionTitle: "OK", cancelTitle: "Cancel", actionHandler: { [self] (input:String?) in
            guard let newUsername = input else {
                AlertManager.showInfoAlertBox(with: "Could not get the username you entered. Please try again...", errorTitle: "Error", in: self, handler: nil)
                return
            }
            FirebaseManager.changeUsername(username: newUsername)
            self.usernameLabel.text = newUsername
        })
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let imageCell = cell as? PhotoGridCell
        imageCell?.imageView.kf.cancelDownloadTask()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var columns: CGFloat
        columns = 2
        
        let spacing: CGFloat = 4
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoPathList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imagePath = photoPathList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGridCell.getDescribingIdentifier(), for: indexPath) as! PhotoGridCell
        cell.configureCell(withPath: imagePath)
        return cell
    }
}

// MARK: - FirebaseManagerDelegate
extension ProfileViewController: FirebaseManagerDelegate {
    func didUpdateFavourites() {
        setupUI()
        collectionView.reloadData()
    }
    
    func didUpdateBookmarks() {
        setupUI()
        collectionView.reloadData()
    }
    
    
}
