//
//  UrlComponents.swift
//  URLRequestExample
//
//  Created by Наталья Булгакова on 04.04.2022.
//

import UIKit

class UrlRequestComponent: NSURLComponents {
    
    var queryParams: [String: String] = [:]
    
    var pageCount = 0 //кол-во страниц, которые надо подгрузить
    
    var currentPage = 1 //текущая страница, начинаем всегда с первой
    
    var searchString = "2022" //дефолт что бы что-то показать в начале. пустую строку нельзя передавать
    
    let pageSize = "10"
    
    struct News: Decodable {
        let status: String
        let totalResults: Int
        let articles: [Article]
    }
    
    struct Article: Decodable {
        let title: String
        //let urlToImage: String //на потом
    }
    
    private func getQueryParams() -> [String: String] { //в зависимости от того первый это запрос или нет, мы берем либо параметры без номера страницы, либо с номером, когда уже посчитали сколько будет страниц
        
        if pageCount == 0 {
            return [
                "q": "\(searchString)",
                "pageSize": "\(pageSize)"
            ]
        } else {
            return [
                "q": "\(searchString)",
                "pageSize": "\(pageSize)",
                "page": "\(currentPage)"
            ]
        }
    }
    
    private func createNewRequest() -> URLRequest {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "newsapi.org"
        urlComponent.path = "/v2/everything"
        urlComponent.setQueryParams(with: getQueryParams())
        print("createNewRequest \(urlComponent)")
        
        let url = urlComponent.url
        var request = URLRequest(url: url!)
//        request.addValue("026b2fe1f3744c38b02aa0793e534811", forHTTPHeaderField: "X-Api-Key")
        request.addValue("123bef0277b640839e0a66bdbc64ed8d", forHTTPHeaderField: "X-Api-Key")
        return request
    }
    
    private func setPageCount(_ totalResults: Int){
        let pageSize = Int(pageSize) //тут узнаём сколько у нас страниц
        
        if ((totalResults % pageSize!) != 0){
            pageCount = (totalResults/pageSize!)+1
        } else {
            pageCount = (totalResults/pageSize!)
        }
    }
    

    func searchNews(userCompletionHandler: @escaping (News?, Error?) -> Void){

        let request = createNewRequest()
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            if let error = error {
                print("HTTP Request Failed \(error)")
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let jsonNews = try decoder.decode(News.self, from: data)
                    
                    let totalResults = jsonNews.totalResults
                    self.setPageCount(totalResults)
                    
                    userCompletionHandler(jsonNews, nil)

                } catch let parseErr {
                    print("JSON Parsing Error", parseErr)
                    userCompletionHandler(nil, parseErr)
                }
            }
        }.resume()
    }
}

extension URLComponents { //честно украдено
    
    mutating func setQueryParams(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
