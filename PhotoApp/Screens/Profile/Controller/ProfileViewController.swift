//
//  ProfileViewController.swift
//  Crypto App
//
//  Created by Murat ŞENOL on 12.10.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile"
        //navigationController?.tabBarItem.title = LocalizedString.movieTabTitle
        navigationController?.tabBarItem.image = UIImage(named: "person")
        //navigationController?.tabBarItem.selectedImage = UIImage(named: "house.fill")
        
        
    }
    

   

}
