import UIKit
import Alamofire

typealias Parameter = Parameters

let PGNetwork = _PGNetwork.default

// MARK: - PGNetworkError
enum PGError: Error {
    case ResponseError
    case RequestError
    case DecodeError
    case ConvertParameterError
    case JSONSerializationError
}

class _PGNetwork {
    public static let `default` = _PGNetwork()
    
    private let apiVersion: String = "v1"
    private let headers: HTTPHeaders = [.contentType("application/json")]
    
    public let pagingSize: Int = 20
    public var baseURI: URL = URL(string: "https://api.pullgo.kr/\(PGNetwork.apiVersion)")!
    
    
    // MARK: - Public Methods
    public func appendURL(_ urls: String...) -> URL {
        let url = self.baseURI
        return url.appendingURL(urls)
    }
    
    public func get<T: Decodable>(url: URL, type: T.Type, completion: @escaping ((T) -> ())) {
        AF.request(url).response { response in
            switch response.result {
            case .success(let d):
                do {
                    if let receivedData = d {
                        let receivedObject = try receivedData.toObject(type: type)
                        completion(receivedObject)
                    }
                } catch {
                    fatalError("JSON Decode Error -> \(error.localizedDescription)")
                }
            case .failure(_):
                self.presentNetworkAlert()
            }
        }
    }
    
    public func post(url: URL, parameter: Encodable, completion: (() -> Void)? = nil) {
        guard let param = try? parameter.toParameter() else { return }
        
        self.post(url: url, parameter: param, completion: completion)
    }
    
    public func post(url: URL, parameter: Parameters, completion: (() -> Void)? = nil) {
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success(_):
                completion?()
            case .failure(_):
                self.presentNetworkAlert()
            }
        }
    }
    
    public func patch(url: URL, parameter: Encodable, completion: (() -> Void)? = nil) {
        guard let param = try? parameter.toParameter() else { return }
        
        AF.request(url, method: .patch, parameters: param, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success(_):
                completion?()
            case .failure(_):
                self.presentNetworkAlert()
            }
        }
    }
    
    public func delete(url: URL, completion: (() -> Void)? = nil) {
        AF.request(url, method: .delete).response { response in
            switch response.result {
            case .success(_):
                completion?()
            case .failure(_):
                self.presentNetworkAlert()
            }
        }
    }
    
    // MARK: - Private Methods
    private func presentNetworkAlert() {
        guard let topViewController = UIApplication.shared.topViewController else { return }
        
        let alert = PGAlertPresentor(presentor: topViewController)
        alert.presentNetworkError()
    }
}

extension Data {
    public func toObject<T: Decodable>(type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        var decodedData: T
        
        do {
            decodedData = try decoder.decode(type, from: self)
        } catch {
            throw PGError.DecodeError
        }
        
        return decodedData
    }
}

extension Encodable {
    
    func toParameter(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String : Any] {
        guard let data = try? encoder.encode(self) else {
            print("Convert Parameter Error!")
            throw PGError.ConvertParameterError
        }
        guard let object = try? JSONSerialization.jsonObject(with: data) else {
            print("JSON Serialization Error!")
            throw PGError.JSONSerializationError
        }
        guard let json = object as? [String : Any] else {
            let content = DecodingError.Context(codingPath: [], debugDescription: "Deserialized data is not dictionary")
            throw DecodingError.typeMismatch(type(of: object), content)
        }
        
        return json
    }
}

extension URL {
    
    public func appendingURL(_ urls: [String]) -> URL {
        var result = self
        for url in urls {
            result.appendPathComponent(url)
        }
        return result
    }
    
    public func appendingQuery(_ items: [URLQueryItem]) -> URL {
        guard var components = URLComponents(string: self.absoluteString) else {
            print("URL::appendQuery() -> URL to Component fail.")
            return PGNetwork.baseURI
        }
        
        for item in items {
            components.queryItems?.append(item)
        }
        
        do {
            return try components.asURL()
        } catch {
            print(error.localizedDescription)
            return PGNetwork.baseURI
        }
    }
    
    public func pagination(page: Int) -> URL {
        let sizeQuery = URLQueryItem(name: "size", value: String(PGNetwork.pagingSize))
        let pageQuery = URLQueryItem(name: "page", value: String(page))
        return self.appendingQuery([sizeQuery, pageQuery])
    }
}

extension UIApplication {
    public var topViewController: UIViewController? {
        var rootViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController

        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        } else if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        
        if rootViewController?.presentedViewController != nil {
            rootViewController = rootViewController?.presentedViewController
        }
        
        return rootViewController
    }
}
