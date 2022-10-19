//
//  SearchViewModel.swift
//  PhotoApp
//
//  Created by Murat ŞENOL on 13.10.2022.
//

import Foundation

protocol SearchDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didGetSearched(_ response: SearchedPhotos.Response)
    func didGetPopular(_ response: PopularPhotos.Response)
}

final class SearchViewModel {
    weak var delegate: SearchDelegate?
    
    private(set) var searchResponse: SearchedPhotos.Response? {
        didSet {
            delegate?.didGetSearched(searchResponse!)
        }
    }
    
    private(set) var popularResponse: PopularPhotos.Response? {
        didSet {
            delegate?.didGetPopular(popularResponse!)
        }
    }
    
    init() {}
    
    func fetchSearched(_ request: SearchedPhotos.Request){
        provider.request(.search(text: request.text, per_page: String(request.per_page), page: String(request.page))) { result in
            print("RESULT: \(result)" )
            switch result {
            case .failure(let error):
                self.delegate?.didErrorOccurred(error)
            case .success(let response):
                do {
                    let searchResponse = try JSONDecoder().decode(SearchedPhotos.Response.self, from: response.data)
                    self.searchResponse = searchResponse
                } catch {
                    self.delegate?.didErrorOccurred(error)
                }
            }
        }
    }
    
    func fetchPopular(_ request: PopularPhotos.Request){
        provider.request(.popular(per_page: String(request.per_page), page: String(request.page))) { result in
            print("RESULT: \(result)" )
            switch result {
            case .failure(let error):
                self.delegate?.didErrorOccurred(error)
            case .success(let response):
                do {
                    let popularResponse = try JSONDecoder().decode(PopularPhotos.Response.self, from: response.data)
                    self.popularResponse = popularResponse
                } catch {
                    self.delegate?.didErrorOccurred(error)
                }
            }
        }
    }
}
