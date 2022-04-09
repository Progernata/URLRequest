//
//  Networker.swift
//  URLRequestExample
//
//  Created by Aleksandr Lis on 09.04.2022.
//

import Foundation

struct Networker {
    
    private let queue = DispatchQueue.global(qos: .utility)
    
    func sendRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        
        queue.async {
            URLSession.shared.dataTask(with: request) { data, responce, error in
                if let error = error {
                    print("HTTP Request Failed \(error)")
                    completion(.failure(error))
                    return
                    
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(T.self, from: data)
                        completion(.success(model))

                    } catch let parseErr {
                        print("JSON Parsing Error", parseErr)
                        completion(.failure(parseErr))
                    }
                }
            }.resume()
        }
    }
}
