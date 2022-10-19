//
//  RecentViewController.swift
//  Crypto App
//
//  Created by Murat ŞENOL on 12.10.2022.
//

import UIKit
import Toast

class RecentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: RecentViewCell.getNibName(), bundle: nil), forCellReuseIdentifier: RecentViewCell.getDescribingIdentifier())
        }
    }
    
    private var viewModel = RecentViewModel()
    private var pageCounter: Int = 1
    private var totalPhotoCount: Int = 0
    private var photoList: [Photo] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Recent"
        navigationController?.tabBarItem.image = UIImage(named: "photo")
        
        viewModel.delegate = self
        viewModel.fetchRecent(.init(per_page: 50, page: pageCounter))
    }
    
}

extension RecentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photoList.count - 1{
            //Check if there are anymore photos to load
            if photoList.count < totalPhotoCount{
                //Load more content
                tableView.showTableViewLoadingIndicator()
                viewModel.fetchRecent(.init(per_page: 50, page: pageCounter))
            }
        }
    }
     
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as? MovieDetailViewController{
            
            //Preperation
            detailVC.movieID = popularMovieList[indexPath.row].id
            tableView.deselectRow(at: indexPath, animated: false)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    */
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let photoCell = cell as? RecentViewCell
        photoCell?.pictureImageView.kf.cancelDownloadTask()
    }
}

extension RecentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = photoList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentViewCell.getDescribingIdentifier(), for: indexPath) as! RecentViewCell
        cell.delegate = self
        cell.configureCell(with: photo)
        return cell
    }
}

extension RecentViewController: RecentsDelegate {
    func didErrorOccurred(_ error: Error) {
        tableView.hideTableViewLoadingIndicator()
        // TODO: show alert
        print("ERROR: \(error)")
    }
    
    func didGetRecent(_ response: RecentPhotos.Response) {
        tableView.hideTableViewLoadingIndicator()
        photoList.append(contentsOf: response.result.photos)
        totalPhotoCount = response.result.total
        pageCounter += 1
    }
}

extension RecentViewController: RecentViewCellDelegate {
    func didAddFavourites() {
        self.view.makeToast("Succesfully added to favourites", duration: 3.0, position: .bottom)
    }
    
    func didAddBookmarks() {
        self.view.makeToast("Succesfully added to bookmarks", duration: 3.0, position: .bottom)
    }
}


