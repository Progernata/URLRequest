//
//  News.swift
//  URLRequestExample
//
//  Created by Наталья Булгакова on 19.04.2022.
//

struct News: Decodable {
    struct Article: Decodable {
        let title: String
        let urlToImage: String 
    }
    let status: String
    let totalResults: Int
    let articles: [Article]
}


