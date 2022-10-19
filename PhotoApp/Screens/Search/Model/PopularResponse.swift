//
//  PopularResponse.swift
//  PhotoApp
//
//  Created by Murat ŞENOL on 13.10.2022.
//

import Foundation

struct PopularPhotos: Codable {
    
    struct Request {
        let per_page: Int
        let page: Int
    }
    
    struct Response: Codable {
        let result: PopularPhotosItem
        let stat: String
        
        enum CodingKeys: String, CodingKey {
            case result = "photos"
            case stat
        }
    }
}

// MARK: - Photos
struct PopularPhotosItem: Codable {
    let photos: [Photo]
    let page, perpage: String
    let pages, total: Int
    
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
        case page
        case pages
        case perpage
        case total
    }
}


