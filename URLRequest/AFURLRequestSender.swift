//
//  AFURLRequestSender.swift
//  
//
//  Created by Наталья Булгакова on 21.04.2022.
//

import UIKit
import Alamofire

class AFURLRequestSender {

    func sendAFURLRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global(qos: .utility).async{
            AF.request(request).responseDecodable(of: T.self){ (data) in
                if let value = data.value {
                    completion(.success(value))
                    print("Use Alamofire")
                } else {
                    completion(.failure(data.error!)) //тут нужна помощь. не знаю как верно тут обрабатывать ошибки
                }
            }
        }
    }
    
    func sendAFURLRequestWithRouter<T: Decodable>(_ request: NewsRouter, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global(qos: .utility).async{
            AF.request(request).responseDecodable(of: T.self){ (data) in
                if let value = data.value {
                    completion(.success(value))
                    print("Use Alamofire")
                } else {
                    completion(.failure(data.error!)) //тут нужна помощь. не знаю как верно тут обрабатывать ошибки
                }
            }
        }
    }
}

