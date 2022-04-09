//
//  News.swift
//  URLRequestExample
//
//  Created by Aleksandr Lis on 09.04.2022.
//

import Foundation

struct News: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
    //let urlToImage: String //на потом
}
