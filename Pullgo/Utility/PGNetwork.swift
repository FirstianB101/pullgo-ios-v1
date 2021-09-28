import UIKit
import Alamofire

typealias Parameter = Parameters
typealias PGNetworkError = AFError

let PGNetwork = _PGNetwork.shared

// MARK: - PGNetworkError
enum PGError: Error {
    case DecodeError
    case ConvertParameterError
    case JSONSerializationError
}

class _PGNetwork {
    static let shared = _PGNetwork()
    
    private let apiVersion: String = "v1"
    private let headers: HTTPHeaders = [.contentType("application/json")]
    private var headerWithToken: HTTPHeaders? {
        if let token = PGSignedUser.token {
            var header = headers
            header.add(.authorization(bearerToken: token))
            return header
        }
        return nil
    }
    
    public let pagingSize: Int = 20
    public var baseURI: URL
    
    init() {
        self.baseURI = URL(string: "https://api.pullgo.kr/\(self.apiVersion)")!
    }
    
    // MARK: - Public Methods
    public func appendURL(_ urls: String...) -> URL {
        let url = self.baseURI
        return url.appendingURL(urls)
    }
    
    public func get<T: Decodable>(url: URL, type: T.Type, success: @escaping ((T) -> ()), fail: ((AFError) -> Void)? = nil) {
        AF.request(url, method: .get, headers: self.headerWithToken).response { response in
            switch response.result {
            case .success(let d):
                do {
                    if let receivedData = d {
                        let receivedObject = try receivedData.toObject(type: type)
                        success(receivedObject)
                    }
                } catch {
                    fatalError("JSON Decode Error -> \(error.localizedDescription)")
                }
            case .failure(let e):
                if let failClosure = fail {
                    failClosure(e)
                } else if e.responseCode == 401 {
                    self.presentUnauthorizedAlert()
                } else {
                    self.presentNetworkAlert()
                }
            }
        }
    }
    
    public func post(url: URL, parameter: Encodable, success: ((Data?) -> Void)? = nil, fail: ((AFError) -> Void)? = nil) {
        guard let param = try? parameter.toParameter() else { return }
        
        self.post(url: url, parameter: param, success: success, fail: fail)
    }
    
    public func post(url: URL, parameter: Parameters, success: ((Data?) -> Void)? = nil, fail: ((AFError) -> Void)? = nil) {
        
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: self.headerWithToken).response { response in
            switch response.result {
            case .success(let d):
                success?(d)
            case .failure(let e):
                if let failClosure = fail {
                    failClosure(e)
                } else if e.responseCode == 401 {
                    self.presentUnauthorizedAlert()
                } else {
                    self.presentNetworkAlert()
                }
            }
        }
    }
    
    public func patch(url: URL, parameter: Encodable, success: ((Data?) -> Void)? = nil, fail: ((AFError) -> Void)? = nil) {
        guard let param = try? parameter.toParameter() else { return }
        
        AF.request(url, method: .patch, parameters: param, encoding: JSONEncoding.default, headers: self.headerWithToken).response { response in
            switch response.result {
            case .success(let d):
                success?(d)
            case .failure(let e):
                if let failClosure = fail {
                    failClosure(e)
                } else if e.responseCode == 401 {
                    self.presentUnauthorizedAlert()
                } else {
                    self.presentNetworkAlert()
                }
            }
        }
    }
    
    public func delete(url: URL, success: (() -> Void)? = nil, fail: ((AFError) -> Void)? = nil) {
        AF.request(url, method: .delete, headers: self.headerWithToken).response { response in
            switch response.result {
            case .success(_):
                success?()
            case .failure(let e):
                if let failClosure = fail {
                    failClosure(e)
                } else if e.responseCode == 401 {
                    self.presentUnauthorizedAlert()
                } else {
                    self.presentNetworkAlert()
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func presentNetworkAlert() {
        guard let topViewController = UIApplication.shared.topViewController else { return }
        
        let alert = PGAlertPresentor(presentor: topViewController)
        alert.presentNetworkError()
    }
    
    private func presentUnauthorizedAlert() {
        guard let topViewController = UIApplication.shared.topViewController else { return }
        
        let alert = PGAlertPresentor(presentor: topViewController)
        alert.present(title: "알림", context: "로그인 정보가 만료되었습니다. 다시 로그인 후 풀고를 이용해주세요!") { handler in
            // 로그인 화면으로 돌아가기
        }
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
    
    public func pagination(page: Int, size: Int = 20) -> URL {
        let sizeQuery = URLQueryItem(name: "size", value: String(size))
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
