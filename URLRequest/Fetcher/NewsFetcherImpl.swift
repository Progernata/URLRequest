//
//  NewsFetcherImpl.swift
//  URLRequestExample
//
//  Created by Aleksandr Lis on 18.05.2022.
//

import Foundation

class NewsFetcherImpl: NewsFetcher {

    private let urlRequestSender: URLRequestSender
    private let afurlRequestSender: AFURLRequestSender
    
    init(urlRequestSender: URLRequestSender, afurlRequestSender: AFURLRequestSender){
        self.urlRequestSender = urlRequestSender
        self.afurlRequestSender = afurlRequestSender
    }
    
    func getNews(searchText: String, page: Int, pageSize: Int, completion: @escaping (Result<News, Error>) -> Void) {
        
        //let params = getQueryParams(searchText: searchText, page: page, pageSize: pageSize)
        //let request = createNewRequest(params: params)
        //urlRequestSender.sendURLRequest(request, completion: completion) //старый вызов
        
        //afurlRequestSender.sendAFURLRequest(request, completion: completion) // Alamofire без роутера
        
        if page > 1 {
            afurlRequestSender.sendAFURLRequestWithRouter(NewsRouter.pagination(searchText, page), completion: completion) // Alamofire с роутером, работает при пагинации
        } else {
            afurlRequestSender.sendAFURLRequestWithRouter(NewsRouter.search(searchText), completion: completion) // Alamofire с роутером, работает только при запуске
        }
    }
    
    func downloadImageData(imageUrl: String, completion: @escaping (Data?) -> Void ){
        
        let url = URL(string: imageUrl)!
        afurlRequestSender.downloadAFURLImage(url, completion: completion)
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
    
    private func getQueryParams(searchText: String, page: Int, pageSize: Int) -> [String: String] {
        var queryParams = [
            "q": "\(searchText)",
            "pageSize": "\(pageSize)"
        ]
        if page > 1 {
            queryParams["page"] = "\(page)"
        }
        return queryParams
    }
}

extension URLComponents {

    mutating func setQueryParams(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}