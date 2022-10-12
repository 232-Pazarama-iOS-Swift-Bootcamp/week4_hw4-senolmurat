//
//  FlickrAPI.swift
//  Crypto App
//
//  Created by Murat ŞENOL on 12.10.2022.
//

import Moya

let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
let provider = MoyaProvider<FlickrAPI>(plugins: [plugin])

enum FlickrAPI {
    case recent(method: String = "flickr.photos.getRecent", api_key: String = "55f3f75e00ac276da38071522de9c95a", per_page: String, page: String, format: String = "json", nojsoncallback: String = "1")
    case search(method: String = "flickr.photos.search", api_key: String = "55f3f75e00ac276da38071522de9c95a",text: String ,per_page: String, page: String, format: String = "json", nojsoncallback: String = "1")
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
        case .recent(let method, let api_key, let per_page, let page, let format, let nojsoncallback):
            let parameters = ["method" : method,
                              "api_key" : api_key,
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
