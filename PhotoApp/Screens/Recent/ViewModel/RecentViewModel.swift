//
//  PhotoViewModel.swift
//  Crypto App
//
//  Created by Murat ŞENOL on 12.10.2022.
//

import Foundation


protocol RecentsDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didGetRecent(_ response: RecentPhotos.Response)
}

final class RecentViewModel {
    weak var delegate: RecentsDelegate?
    
    private(set) var recentResponse: RecentPhotos.Response? {
        didSet {
            delegate?.didGetRecent(recentResponse!)
        }
    }
    
    init() {}
    
    func fetchRecent(_ request: RecentPhotos.Request){
        provider.request(.recent(per_page: String(request.per_page), page: String(request.page))) { result in
            switch result {
            case .failure(let error):
                self.delegate?.didErrorOccurred(error)
            case .success(let response):
                do {
                    let recentResponse = try JSONDecoder().decode(RecentPhotos.Response.self, from: response.data)
                    self.recentResponse = recentResponse
                } catch {
                    self.delegate?.didErrorOccurred(error)
                }
            }
        }
    }
}

