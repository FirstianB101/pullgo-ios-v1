//
//  NetworkManager.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation
import Alamofire

public let NetworkManager = Network.default

open class Network {
    
    public static let `default` = Network()
    
    private let version: String = "v1"
    var url: URL {
        URL(string: "https://api.pullgo.kr/\(self.version)")!
    }
    
    open func assembleURL(components: [String]) -> URL {
        var urlResult = url
        
        for component in components {
            urlResult.appendPathComponent(component)
        }
        
        return urlResult
    }
    
    open func post(url: URL, data: Encodable) -> Data? {
        guard let param = try? data.toParameter() else { return nil }
        
        print(param)
        
        var data: Data? = nil
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).response { response in
            data = response.data
        }
        
        return data
    }
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

enum NetworkError: Error {
    case convertParameterError
    case JSONSerializationError
}
