//
//  PGNetworkable.swift
//  Pullgo
//
//  Created by 김세영 on 2021/09/19.
//

import Foundation

public struct PGURLs: RawRepresentable {
    
    public static let token:        URL = PGNetwork.appendURL("auth", "token")
    public static let me:           URL = PGNetwork.appendURL("auth", "me")
    public static let academies:    URL = PGNetwork.appendURL("academies")
    public static let classrooms:   URL = PGNetwork.appendURL("academy", "classrooms")
    public static let lessons:      URL = PGNetwork.appendURL("academy", "classroom", "lessons")
    public static let exams:        URL = PGNetwork.appendURL("exams")
    public static let questions:    URL = PGNetwork.appendURL("exam", "questions")
    public static let teachers:     URL = PGNetwork.appendURL("teachers")
    public static let students:     URL = PGNetwork.appendURL("students")

    public let rawValue: URL

    public init(rawValue: URL) {
        self.rawValue = rawValue
    }
}

class PGNetworkable: Codable {
    var id: Int?
    var url: URL!
    
    enum CodingKeys: CodingKey {
        case id
    }
    
    init(url: URL) {
        self.url = url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
    }
     
    public func pagination(page: Int, size: Int = PGNetwork.pagingSize) {
        self.url = self.url.pagination(page: page, size: size)
    }
        
    public func get<T: Decodable>(type: T.Type, success: @escaping ((T) -> ()), fail: ((PGNetworkError) -> Void)? = nil) {
        guard let id = self.id else {
            print("PGNetworkable::get() -> id is nil.")
            return
        }
        
        PGNetwork.get(url: url.appendingURL([String(id)]), type: type, success: success, fail: fail)
    }
    
    public func post(success: ((Data?) -> Void)? = nil, fail: ((PGNetworkError) -> Void)? = nil) {
//        guard let id = self.id else {
//            print("PGNetworkable::post() -> id is nil.")
//            return
//        }
        PGNetwork.post(url: url, parameter: self, success: success, fail: fail)
    }
    
    public func patch(success: ((Data?) -> Void)? = nil, fail: ((PGNetworkError) -> Void)? = nil) {
        guard let id = self.id else {
            print("PGNetworkable::patch() -> id is nil.")
            return
        }
        
        PGNetwork.patch(url: url.appendingURL([String(id)]), parameter: self, success: success, fail: fail)
    }
    
    public func delete(success: ((Data?) -> Void)? = nil, fail: ((PGNetworkError) -> Void)? = nil) {
        guard let id = self.id else {
            print("PGNetworkable::delete() -> id is nil.")
            return
        }
        
        PGNetwork.delete(url: url.appendingURL([String(id)]), success: success, fail: fail)
    }
}
