//
//  SearchDetailViewController.swift
//  PhotoApp
//
//  Created by Murat ŞENOL on 16.10.2022.
//

import UIKit

class SearchDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: RecentViewCell.getNibName(), bundle: nil), forCellReuseIdentifier: RecentViewCell.getDescribingIdentifier())
        }
    }
    
    var photo: Photo?
    
    /*
    init(tableView: UITableView!, photo: Photo) {
        self.tableView = tableView
        self.photo = photo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

}

extension SearchDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let photoCell = cell as? RecentViewCell
        photoCell?.pictureImageView.kf.cancelDownloadTask()
    }
}

extension SearchDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let photo = photo else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentViewCell.getDescribingIdentifier(), for: indexPath) as! RecentViewCell
        cell.delegate = self
        cell.configureCell(with: photo)
        return cell
    }
}

extension SearchDetailViewController: RecentViewCellDelegate {
    func didAddFavourites() {
        self.view.makeToast("Succesfully added to favourites", duration: 3.0, position: .bottom)
    }
    
    func didAddBookmarks() {
        self.view.makeToast("Succesfully added to bookmarks", duration: 3.0, position: .bottom)
    }
}

