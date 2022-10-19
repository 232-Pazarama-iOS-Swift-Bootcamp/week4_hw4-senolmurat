//
//  SearchViewController.swift
//  Crypto App
//
//  Created by Murat ŞENOL on 12.10.2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: PhotoGridCell.getNibName(), bundle: nil), forCellWithReuseIdentifier: PhotoGridCell.getDescribingIdentifier())
        }
    }
    
    private var lastEnteredText: String = ""
    private var isInSearchMode: Bool = false
    private var viewModel = SearchViewModel()
    private var pageCounter: Int = 1
    private var totalPhotoCount: Int = 0
    private var photoList: [Photo] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        //navigationController?.tabBarItem.title = LocalizedString.movieTabTitle
        navigationController?.tabBarItem.image = UIImage(named: "search")
        //navigationController?.tabBarItem.selectedImage = UIImage(named: "house.fill")
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search something..."
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        viewModel.delegate = self
        viewModel.fetchPopular(.init(per_page: 50, page: pageCounter))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = SearchDetailViewController()
        detailVC.photo = photoList[indexPath.row]
        detailVC.providesPresentationContextTransitionStyle = true
        detailVC.definesPresentationContext = true
        //detailVC.modalPresentationStyle = .currentContext
        detailVC.view.backgroundColor = UIColor.shadow
        //navigationController?.pushViewController(detailVC, animated: true)
        self.present(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photoList.count - 1{
            //Check if there are anymore photos to load
            if photoList.count < totalPhotoCount{
                //Load more content
                if isInSearchMode {
                    viewModel.fetchSearched(.init(text: lastEnteredText, per_page: 50, page: pageCounter))
                } else {
                    viewModel.fetchPopular(.init(per_page: 50, page: pageCounter))
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let imageCell = cell as? PhotoGridCell
        imageCell?.imageView.kf.cancelDownloadTask()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
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
extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = photoList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGridCell.getDescribingIdentifier(), for: indexPath) as! PhotoGridCell
        cell.configureCell(with: photo)
        return cell
    }
    
    
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 2 {
            photoList.removeAll()
            pageCounter = 1
            lastEnteredText = text
            viewModel.fetchSearched(.init(text: text, per_page: 50, page: pageCounter))
        } else if let text = searchController.searchBar.text, text.count == 0 {
            pageCounter = 1
            photoList.removeAll()
            viewModel.fetchPopular(.init(per_page: 50, page: pageCounter))
        }
    }
}

// MARK: - SearchDelegate
extension SearchViewController: SearchDelegate {
    func didErrorOccurred(_ error: Error) {
        // TODO: show alert
        print("ERROR: \(error)")
    }
    
    func didGetSearched(_ response: SearchedPhotos.Response) {
        isInSearchMode = true
        photoList.append(contentsOf: response.result.photos)
        totalPhotoCount = response.result.total
        pageCounter += 1
    }
    
    func didGetPopular(_ response: PopularPhotos.Response) {
        isInSearchMode = false
        photoList.append(contentsOf: response.result.photos)
        totalPhotoCount = response.result.total
        pageCounter += 1
    }
    
    
}

