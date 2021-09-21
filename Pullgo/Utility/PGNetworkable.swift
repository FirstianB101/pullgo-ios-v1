//
//  PGNetworkable.swift
//  Pullgo
//
//  Created by 김세영 on 2021/09/19.
//

import Foundation

public struct PGURLs: RawRepresentable {
    
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
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int.self, forKey: .id)
    }
    
    init(url: URL) {
        self.url = url
    }
    
    func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
    }
        
    public func get(completion: @escaping ((Self) -> ())) {
        guard let id = self.id else {
            print("PGNetworkable::get() -> id is nil.")
            return
        }
        
        PGNetwork.get(url: url.appendingURL([String(id)]), type: Self.self, completion: completion)
    }
//    func copy(_ object: T)
    func post(completion: (() -> ())? = nil) {
        guard let id = self.id else {
            print("PGNetworkable::post() -> id is nil.")
            return
        }
        
        PGNetwork.post(url: url.appendingURL([String(id)]), parameter: self, completion: completion)
    }
    
    func patch(completion: (() -> ())? = nil) {
        guard let id = self.id else {
            print("PGNetworkable::patch() -> id is nil.")
            return
        }
        
        PGNetwork.patch(url: url.appendingURL([String(id)]), parameter: self, completion: completion)
    }
    
    func delete(completion: (() -> ())?) {
        guard let id = self.id else {
            print("PGNetworkable::delete() -> id is nil.")
            return
        }
        
        PGNetwork.delete(url: url.appendingURL([String(id)]), completion: completion)
    }
}
