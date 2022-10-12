//
//  RecentResponse.swift
//  Crypto App
//
//  Created by Murat ŞENOL on 12.10.2022.
//

import Foundation

struct RecentPhotos: Codable {
    
    struct Request {
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

// MARK: - Photos
struct Photos: Codable {
    let photos: [Photo]
    let page, pages, perpage, total: Int
    
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
        case page
        case pages
        case perpage
        case total
    }
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server, title: String
    let ispublic, isfriend, isfamily: Int
    
    var imagePath: String {
        return "https://live.staticflickr.com/\(server)/\(id)_\(secret)_w.jpg"
    }
    
    var imagePathLarge: String {
        return "https://live.staticflickr.com/\(server)/\(id)_\(secret)_b.jpg"
    }
}
