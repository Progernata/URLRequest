//
//  NewsRouter.swift
//  URLRequestExample
//
//  Created by Наталья Булгакова on 21.04.2022.
//

import Foundation
import Alamofire

public enum NewsRouter: URLRequestConvertible {
    enum Constants {
        static let baseURLPath = "https://newsapi.org/v2"
        static let apiKey = "123bef0277b640839e0a66bdbc64ed8d"
        static let pageSize = 10
    }
    
    case search(String)
    case pagination(String, Int)
    
    var method: HTTPMethod {
      switch self {
      case .search, .pagination:
          return .get
      }
    }
    
    var path: String {
      switch self {
      case .search, .pagination:
          return "/everything"
      }
    }
    
    var parameters: [String: Any] {
      switch self {
      case .search(let searchText):
          return ["q": searchText, "pageSize": "\(Constants.pageSize)"]
      case .pagination(let searchText, let page):
          return ["q": searchText, "pageSize": "\(Constants.pageSize)", "page": "\(page)"]
      }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(Constants.apiKey, forHTTPHeaderField: "X-Api-Key")

        return try URLEncoding.default.encode(request, with: parameters)
    }
}
