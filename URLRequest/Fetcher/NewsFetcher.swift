//
//  NewsFetcher.swift
//  URLRequestExample
//
//  Created by Наталья Булгакова on 20.04.2022.
//

import Foundation
import Alamofire

protocol NewsFetcher {
    func getNews(searchText: String, page: Int, pageSize: Int, completion: @escaping (Result<News, Error>) -> Void)
}


