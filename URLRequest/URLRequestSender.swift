//
//  URLRequestSender.swift
//  URLRequestExample
//
//  Created by Наталья Булгакова on 20.04.2022.
//

import Foundation

class URLRequestSender {
    
    func sendURLRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            URLSession.shared.dataTask(with: request) { data, responce, error in
                if let error = error {
                    print("HTTP Request Failed \(error)")
                    completion(.failure(error))
                    return
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        completion(.success(result))

                    } catch let parseErr {
                        print("JSON Parsing Error", parseErr)
                        completion(.failure(parseErr))
                    }
                }
            }.resume()
        }
    }
}
