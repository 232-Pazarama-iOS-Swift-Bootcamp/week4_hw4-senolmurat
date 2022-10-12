//
//  RecentViewController.swift
//  Crypto App
//
//  Created by Murat ŞENOL on 12.10.2022.
//

import UIKit

class RecentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: RecentViewCell.getNibName(), bundle: nil), forCellReuseIdentifier: RecentViewCell.getDescribingIdentifier())
        }
    }
    
    private var viewModel = RecentViewModel()
    private var photoList: [Photo] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Recent"
        //navigationController?.tabBarItem.title = LocalizedString.movieTabTitle
        navigationController?.tabBarItem.image = UIImage(named: "photo")
        //navigationController?.tabBarItem.selectedImage = UIImage(named: "house.fill")
        
        
        viewModel.delegate = self
        viewModel.fetchRecent(.init(per_page: 50, page: 1))
        //photoList.append(contentsOf: viewModel.)
    }
    
}

extension RecentViewController: UITableViewDelegate {
    /*
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == popularMovieList.count - 1{
            
            guard let totalMovieCount = totalPopularMovieCount else {
                return
            }
            
            //Check if there are anymore characters to load
            if popularMovieList.count < totalMovieCount{
                //Load more content
                tableView.showTableViewLoadingIndicator()
                
                movieService.getPopular(page: popularListPageCounter , language: AppConfig.languageISO) { result in
                    switch result {
                    case .success(let response):
                        self.popularListPageCounter += 1
                        self.popularMovieList.append(contentsOf: response.results)
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
     */
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
        cell.configureCell(with: photo)
        return cell
    }
}

extension RecentViewController: RecentsDelegate {
    func didErrorOccurred(_ error: Error) {
        // TODO: show alert
        print("ERROR: \(error)")
    }
    
    func didGetRecent(_ response: RecentPhotos.Response) {
        photoList.append(contentsOf: response.result.photos)
        //tableView.reloadData()
    }
}


