//
//  NetworkManager.swift
//  Pullgo
//
//  Created by 김세영 on 2021/06/28.
//

import Foundation
import Alamofire

class NetworkManager {
    
    private static let version: String = "v1"
    static let url: URL = URL(string: "https://api.pullgo.kr/\(version)")!
    
    static func assembleURL(components: [String]) -> URL {
        var urlResult = url
        
        for component in components {
            urlResult.appendPathComponent(component)
        }
        
        return urlResult
    }
    
    static func post(url: URL, data: Encodable) -> Decodable {
    
    }
    
    private static func convertJSON(data: Encodable) -> Data? {
        var result: Data?
        do {
//            result = try JSONEncoder().encode(data)
        } catch {
            print("NetworkManager.convertJSON(): convert json failed.")
            result = nil
        }
        
        return result
    }
}
