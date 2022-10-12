//
//  SearchViewController.swift
//  Crypto App
//
//  Created by Murat ŞENOL on 12.10.2022.
//

import UIKit

class SearchViewController: UIViewController {

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

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 2 {
            
        }
    }
}

