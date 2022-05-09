//
//  NewsFetcher.swift
//  URLRequestExample
//
//  Created by Наталья Булгакова on 20.04.2022.
//

import Foundation

class NewsFetcher: ApiFetcherProtocol {

    private let urlRequestSender: URLRequestSender
    private let afurlRequestSender: AFURLRequestSender
    
    private let isMock = true
    //private let isMock = false
    
    init(urlRequestSender: URLRequestSender, afurlRequestSender: AFURLRequestSender){
        self.urlRequestSender = urlRequestSender
        self.afurlRequestSender = afurlRequestSender
    }
    
    func getNews(searchText: String, page: Int, pageSize: Int, completion: @escaping (Result<News, Error>) -> Void) {
        
        guard isMock == false else {
            let news = self.fetchFromJson(fileName: "MockNewsOnePage", modelType: News.self)
            print("Use mock!!!")
            return completion(.success(news))
        }
        
        //let params = getQueryParams(searchText: searchText, page: page, pageSize: pageSize)
        //let request = createNewRequest(params: params)
        //urlRequestSender.sendURLRequest(request, completion: completion) //старый вызов
        
        //afurlRequestSender.sendAFURLRequest(request, completion: completion) // Alamofire без роутера
        
        if page > 1 {
            afurlRequestSender.sendAFURLRequestWithRouter(NewsRouter.search(searchText), completion: completion) // Alamofire с роутером, работает при пагинации
        } else {
            afurlRequestSender.sendAFURLRequestWithRouter(NewsRouter.pagination(searchText, page), completion: completion) // Alamofire с роутером, работает только при запуске
        }
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
    
    private func fetchFromJson<T: Decodable>(fileName: String, modelType: T.Type) -> T {
        guard let sourceUrl = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            fatalError("Can not find file \(fileName).json")
        }
        guard let sourceData = try? Data(contentsOf: sourceUrl) else {
            fatalError("Can not convert data")
        }
        guard let newsData = try? JSONDecoder().decode(T.self, from: sourceData) else {
            fatalError("Error decode of data")
        }
        
        print("readFromFile \(newsData)")
        return newsData
    }
}

extension URLComponents { 

    mutating func setQueryParams(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

protocol ApiFetcherProtocol {
    func getNews(searchText: String, page: Int, pageSize: Int, completion: @escaping (Result<News, Error>) -> Void)
}
