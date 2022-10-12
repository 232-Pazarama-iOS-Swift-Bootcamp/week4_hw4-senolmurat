//
//  RecentViewCell.swift
//  Crypto App
//
//  Created by Murat ŞENOL on 12.10.2022.
//

import UIKit

class RecentViewCell: UITableViewCell {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(with photo: Photo){
        pictureImageView.setImage(withPath: photo.imagePath)
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        bookmarkButton.backgroundColor = .systemGray
        likeButton.backgroundColor = .systemRed
    }
    
    @IBAction func bookmarkButtonPressed(_ sender: UIButton) {
        bookmarkButton.backgroundColor = .systemBlue
        likeButton.backgroundColor = .systemGray
    }
}
