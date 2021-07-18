//
//  NetworkManager.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation
import Alamofire
import UIKit

public let NetworkManager = Network.default

typealias ResponseClosure = ((Data?) -> ())
typealias FailClosure = (() -> ())
typealias EmptyClosure = (() -> ())

public class Network {
    
    public static let `default` = Network()
    
    private let version: String = "v1"
    var url: URL {
        URL(string: "https://api.pullgo.kr/\(self.version)")!
    }
    private let headers: HTTPHeaders = [.contentType("application/json")]
    
    func assembleURL(components: [String]) -> URL {
        var urlResult = url
        
        for component in components {
            urlResult.appendPathComponent(component)
        }
        
        return urlResult
    }
    
    func post(url: URL, data: Encodable, success: ResponseClosure? = nil, fail: FailClosure? = nil, complete: EmptyClosure? = nil) {
        guard let param = try? data.toParameter() else { return }
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success(let d):
                DispatchQueue.global().sync {
                    success?(d)
                }
                complete?()
            case .failure(_):
                fail?()
            }
        }
    }
    
    func `get`(url: URL, success: ResponseClosure? = nil, fail: FailClosure? = nil, complete: EmptyClosure? = nil) {
        AF.request(url).response { response in
            switch response.result {
            case .success(let d):
                DispatchQueue.global().sync {
                    success?(d)
                }
                complete?()
            case .failure(_):
                fail?()
            }
        }
    }
}

/// When ViewModel or Somewhere except UIViewController needs to show Network Alert,
/// Use this delegate to print alert
/// In UIViewController of ViewModel, implements
/// `ViewModel.delegate = self`
protocol NetworkAlertDelegate: AnyObject {
    func networkFailAlert()
}

extension Encodable {
    
    func toParameter(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String : Any] {
        guard let data = try? encoder.encode(self) else {
            print("Convert Parameter Error!")
            throw NetworkError.convertParameterError
        }
        guard let object = try? JSONSerialization.jsonObject(with: data) else {
            print("JSON Serialization Error!")
            throw NetworkError.JSONSerializationError
        }
        guard let json = object as? [String : Any] else {
            let content = DecodingError.Context(codingPath: [], debugDescription: "Deserialized data is not dictionary")
            throw DecodingError.typeMismatch(type(of: object), content)
        }
        
        return json
    }
}

extension URL {
    
    mutating func appendQuery(query: URLQueryItem) {
        appendQuery(queryItems: [query])
    }
    
    mutating func appendQuery(queryItems: [URLQueryItem]) {
        var urlComp = URLComponents(string: self.absoluteString)!
        
        urlComp.queryItems = queryItems
        do {
            self = try urlComp.asURL()
        } catch {
            print("Append Query Error!")
        }
    }
}

extension Data {
    
    func toObject<T: Decodable>(_ decoder: JSONDecoder = JSONDecoder(), type: T.Type) throws -> T {
        guard let decoded = try? decoder.decode(type, from: self) else {
            print("Decode Object Error!")
            throw NetworkError.decodeError
        }
        
        return decoded
    }
}

enum NetworkError: Error {
    case convertParameterError
    case JSONSerializationError
    case decodeError
}

