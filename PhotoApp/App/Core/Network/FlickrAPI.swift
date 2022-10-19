//
//  FlickrAPI.swift
//  Crypto App
//
//  Created by Murat ŞENOL on 12.10.2022.
//

import Moya

let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
let provider = MoyaProvider<FlickrAPI>(plugins: [plugin])

private var apiKey: String = "76deea5896053253686dab192da50462"

enum FlickrAPI {
    case recent(method: String = "flickr.photos.getRecent", api_key: String = apiKey, per_page: String, page: String, extras: [String] = ["owner_name"], format: String = "json", nojsoncallback: String = "1")
    case popular(method: String = "flickr.galleries.getPhotos", api_key: String = apiKey,galleryId: String = "72157720420683050", per_page: String, page: String, format: String = "json", nojsoncallback: String = "1")
    case search(method: String = "flickr.photos.search", api_key: String = apiKey,text: String ,per_page: String, page: String, format: String = "json", nojsoncallback: String = "1")
}

// MARK: - TargetType
extension FlickrAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://www.flickr.com/services/rest/") else {
            fatalError("Base URL not found or not in correct format.")
        }
        return url
    }
    
    var path: String {
        switch self {
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .recent(let method, let api_key, let per_page, let page,let extras, let format, let nojsoncallback):
            var parameters = ["method" : method,
                              "api_key" : api_key,
                              "per_page" : per_page,
                              "page" : page,
                              "format" : format,
                              "nojsoncallback" : nojsoncallback]
            if !extras.isEmpty {
                parameters["extras"] = extras.joined(separator: ",")
            }
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.queryString)
        case .popular(let method, let api_key,let galleryId, let per_page, let page, let format, let nojsoncallback):
            let parameters = ["method" : method,
                              "api_key" : api_key,
                              "gallery_id" : galleryId,
                              "per_page" : per_page,
                              "page" : page,
                              "format" : format,
                              "nojsoncallback" : nojsoncallback]
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.queryString)
        case .search(let method, let api_key, let text, let per_page, let page, let format, let nojsoncallback):
            let parameters = ["method" : method,
                              "api_key" : api_key,
                              "text" : text,
                              "per_page" : per_page,
                              "page" : page,
                              "format" : format,
                              "nojsoncallback" : nojsoncallback]
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.queryString)
        }
        
    }
    
    var headers: [String : String]? {
        nil
    }
}
