//
//  PhotoGridCell.swift
//  PhotoApp
//
//  Created by Murat ŞENOL on 13.10.2022.
//

import UIKit

class PhotoGridCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with photo: Photo){
        imageView.setImage(withPath: photo.imagePath)
    }
    
    func configureCell(withPath path: String) {
        imageView.setImage(withPath: path)
    }

}
