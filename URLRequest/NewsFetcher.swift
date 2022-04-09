//
//  NewsFetcher.swift
//  URLRequestExample
//
//  Created by Aleksandr Lis on 09.04.2022.
//

import Foundation

class NewsFetcher {
    
    let networker: Networker
    
    init(networker: Networker) {
        self.networker = networker
    }
    
    func getNews(text: String, page: Int, pageSize: Int, completion: @escaping (Result<News, Error>) -> Void) {
        
        let params = getQueryParams(text: text, page: page, pageSize: pageSize)
        let request = createNewRequest(params: params)
        networker.sendRequest(request, completion: completion)
    }
    
    private func createNewRequest(params: [String: String]) -> URLRequest {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "newsapi.org"
        urlComponent.path = "/v2/everything"
        urlComponent.setQueryParams(with: params)
        print("createNewRequest \(urlComponent)")
        
        let url = urlComponent.url
        var request = URLRequest(url: url!)
//        request.addValue("026b2fe1f3744c38b02aa0793e534811", forHTTPHeaderField: "X-Api-Key")
        request.addValue("123bef0277b640839e0a66bdbc64ed8d", forHTTPHeaderField: "X-Api-Key")
        return request
    }
    
    private func getQueryParams(text: String, page: Int, pageSize: Int) -> [String: String] {
        var dict = [
            "q": "\(text)",
            "pageSize": "\(pageSize)"
        ]
        if page > 0 {
            dict["page"] = "\(page)"
        }
        return dict
    }
}
