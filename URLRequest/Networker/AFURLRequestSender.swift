//
//  AFURLRequestSender.swift
//  
//
//  Created by Наталья Булгакова on 21.04.2022.
//

import UIKit
import Alamofire

class AFURLRequestSender {

//    func sendAFURLRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
//        DispatchQueue.global(qos: .utility).async {
//            AF.request(request).responseDecodable(of: T.self){ (data) in
//                if let value = data.value {
//                    completion(.success(value))
//                    print("Use Alamofire")
//                } else {
//                    completion(.failure(data.error!)) //тут нужна помощь. не знаю как верно тут обрабатывать ошибки
//                }
//            }
//        }
//    }
    
    func sendAFURLRequestWithRouter<T: Decodable>(_ request: NewsRouter, completion: @escaping (Result<T, Error>) -> Void) {
        print("Request is \(request)")
        DispatchQueue.global(qos: .utility).async {
            AF.request(request).responseDecodable(of: T.self){ (data) in
                if let value = data.value {
                    completion(.success(value))
                    print("Use Alamofire With Router")
                } else {
                    completion(.failure(data.error!)) //тут нужна помощь. не знаю как верно тут обрабатывать ошибки
                }
            }
        }
    }
    
    func downloadAFURLImage(_ url: URL, completion: @escaping (Data?) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            AF.request(url).responseData { (response) in
                if response.error == nil {
                    print(response.result)
                    completion(response.data)
                } else {
                    print("Error download image: \(response.error!)")
                }
            }
        }
    }
}

