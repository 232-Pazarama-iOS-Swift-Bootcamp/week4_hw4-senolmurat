//
//  RecentViewCell.swift
//  Crypto App
//
//  Created by Murat ŞENOL on 12.10.2022.
//

import UIKit

protocol RecentViewCellDelegate: AnyObject {
    func didAddFavourites()
    func didAddBookmarks()
}

class RecentViewCell: UITableViewCell {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var ownerName: UILabel!
    
    weak var delegate: RecentViewCellDelegate?
    private var photoPath: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(with photo: Photo){
        pictureImageView.setImage(withPath: photo.imagePath)
        ownerName.text = photo.ownerName ?? "Unknown"
        photoPath = photo.imagePath
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        guard let photoPath = photoPath else {return}
        likeButton.imageView?.animateImage()
        FirebaseManager.addFavourites(photoID: photoPath)
        delegate?.didAddFavourites()
    }
    
    @IBAction func bookmarkButtonPressed(_ sender: UIButton) {
        guard let photoPath = photoPath else {return}
        bookmarkButton.imageView?.animateImage()
        FirebaseManager.addBookmarks(photoID: photoPath)
        delegate?.didAddBookmarks()
    }
}
