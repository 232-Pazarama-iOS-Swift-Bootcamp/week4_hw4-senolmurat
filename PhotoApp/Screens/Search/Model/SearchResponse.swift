//
//  SearchResponse.swift
//  PhotoApp
//
//  Created by Murat ŞENOL on 13.10.2022.
//

import Foundation

struct SearchedPhotos: Codable {
    
    struct Request {
        let text: String
        let per_page: Int
        let page: Int
    }
    
    struct Response: Codable {
        let result: Photos
        let stat: String
        
        enum CodingKeys: String, CodingKey {
            case result = "photos"
            case stat
        }
    }
}
