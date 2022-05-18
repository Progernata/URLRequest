//
//  NewsFetcherMock.swift
//  URLRequestExample
//
//  Created by Aleksandr Lis on 18.05.2022.
//

import Foundation

class NewsFetcherMock: NewsFetcher {
    
    func getNews(searchText: String, page: Int, pageSize: Int, completion: @escaping (Result<News, Error>) -> Void) {
        let news = self.fetchFromJson(fileName: "MockNewsOnePage", modelType: News.self)
        print("Use mock!!!")
        return completion(.success(news))
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
