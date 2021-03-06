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
            var headerWithToken = headers
            headerWithToken.add(.authorization(bearerToken: token))
            return headerWithToken
        }
        return headers
    }
    
    public let pagingSize: Int = 20
    public var baseURI: URL
    
    init() {
        self.baseURI = URL(string: "https://api.pullgo.kr/\(self.apiVersion)")!
    }
    
    // MARK: - Indicator
    lazy var indicatorView = { () -> UIActivityIndicatorView in
        guard let topView = UIApplication.shared.topViewController else { return UIActivityIndicatorView() }
        
        let origin = topView.view.frame.origin
        let size = topView.view.frame.size
        let indicator = UIActivityIndicatorView(frame: CGRect(origin: origin, size: size))
        
        indicator.backgroundColor = .separator
        indicator.alpha = 1
        
        return indicator
    }()
    
    private func startIndicator() {
        guard let topView = UIApplication.shared.topViewController else { return }
        
        topView.view.addSubview(indicatorView)
        indicatorView.startAnimating()
    }
    
    private func stopIndicator() {
        guard let topView = UIApplication.shared.topViewController else { return }
        
        if topView.view.subviews.contains(indicatorView) {
            indicatorView.stopAnimating()
            indicatorView.removeFromSuperview()
        }
    }
    
    // MARK: - Public Methods
    public func appendURL(_ urls: String...) -> URL {
        let url = self.baseURI
        return url.appendingURL(urls)
    }
    
    public func get<T: Decodable>(url: URL, type: T.Type, success: @escaping ((T) -> ()), fail: ((PGNetworkError) -> Void)? = nil) {
        print(url)
        
        startIndicator()
        
        print("##### Token #####")
        print(self.headerWithToken)
        print()
        
        AF.request(url, method: .get, headers: self.headerWithToken).response { response in
            self.stopIndicator()
            switch response.result {
            case .success(let d):
                d?.log()
                
                self.processByStatusCode(code: response.response?.statusCode) {
                    do {
                        if let receivedData = d {
                            let receivedObject = try receivedData.toObject(type: type)
                            success(receivedObject)
                        }
                    }
                    catch {
                        fatalError("JSON Decode Error -> \(error.localizedDescription)")
                    }
                }
            case .failure(let e):
                if let failClosure = fail {
                    failClosure(e)
                } else {
                    self.presentNetworkAlert()
                }
            }
        }
    }
    
    public func post(url: URL, success: ((Data?) -> Void)? = nil, fail: ((PGNetworkError) -> Void)? = nil) {
        print(url)
        
        print("##### Token #####")
        print(self.headerWithToken)
        print()
        
        
        startIndicator()
        AF.request(url, method: .post, headers: self.headerWithToken).response { response in
            self.stopIndicator()
            switch response.result {
                case .success(let d):
                    d?.log()
                    
                    self.processByStatusCode(code: response.response?.statusCode) {
                        success?(d)
                    }
                case .failure(let e):
                    if let failClosure = fail {
                        failClosure(e)
                    } else {
                        self.presentNetworkAlert()
                    }
            }
        }
    }
    
    public func post(url: URL, parameter: Parameter, success: ((Data?) -> Void)? = nil, fail: ((PGNetworkError) -> Void)? = nil) {
        print(url)
        
        print("##### Token #####")
        print(self.headerWithToken)
        print()
        
        
        startIndicator()
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: self.headerWithToken).response { response in
            self.stopIndicator()
            switch response.result {
            case .success(let d):
                d?.log()
                
                self.processByStatusCode(code: response.response?.statusCode) {
                    success?(d)
                }
            case .failure(let e):
                if let failClosure = fail {
                    failClosure(e)
                } else {
                    self.presentNetworkAlert()
                }
            }
        }
    }
    
    public func post<T: Encodable>(url: URL, parameter: T, success: ((Data?) -> Void)? = nil, fail: ((PGNetworkError) -> Void)? = nil) {
        print(url)
        
        print("##### Token #####")
        print(self.headerWithToken)
        print()
        
        
        startIndicator()
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: self.headerWithToken).response { response in
            self.stopIndicator()
            switch response.result {
            case .success(let d):
                d?.log()
                self.processByStatusCode(code: response.response?.statusCode) {
                    success?(d)
                }
            case .failure(let e):
                if let failClosure = fail {
                    failClosure(e)
                } else {
                    self.presentNetworkAlert()
                }
            }
        }
    }
    
    public func patch(url: URL, parameter: Parameter, success: ((Data?) -> Void)? = nil, fail: ((PGNetworkError) -> Void)? = nil) {
        print(url)
        
        print("##### Token #####")
        print(self.headerWithToken)
        print()
        
        
        startIndicator()
        AF.request(url, method: .patch, parameters: parameter, encoding: JSONEncoding.default, headers: self.headerWithToken).response { response in
            self.stopIndicator()
            switch response.result {
            case .success(let d):
                d?.log()
                
                self.processByStatusCode(code: response.response?.statusCode) {
                    success?(d)
                }
            case .failure(let e):
                if let failClosure = fail {
                    failClosure(e)
                } else {
                    self.presentNetworkAlert()
                }
            }
        }
    }
    
    public func delete(url: URL, success: ((Data?) -> Void)? = nil, fail: ((PGNetworkError) -> Void)? = nil) {
        print(url)
        
        startIndicator()
        AF.request(url, method: .delete, headers: self.headerWithToken).response { response in
            self.stopIndicator()
            switch response.result {
            case .success(let d):
                d?.log()
                
                self.processByStatusCode(code: response.response?.statusCode) {
                    success?(d)
                }
            case .failure(let e):
                if let failClosure = fail {
                    failClosure(e)
                } else {
                    self.presentNetworkAlert()
                }
            }
        }
    }
    
    public func uploadImage(image: UIImage, success: ((String) -> Void)? = nil, fail: ((PGNetworkError) -> Void)? = nil) {
        let header: HTTPHeaders = HTTPHeaders(["Content-Type" : "multipart/form-data"])
        let key = "fb3f4ec1a72b2cba1543b813290b538a"
        let parameters = ["key" : key]
        
        guard let data = image.jpegData(compressionQuality: 1) else {
            print("PGNetwork::uploadImage(image:success:fail:) -> convert image to data failed.")
            return
        }
        
        let url = URL(string: "https://api.imgbb.com/1/upload")!
        
        startIndicator()
        AF.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain")
            }
            
            multipartFormData.append(data, withName: "image", fileName: "pullgo_swift_testpicture_upload.jpg", mimeType: "image/jpg")
            
        }, to: url, method: .post, headers: header).response { response in
            self.stopIndicator()
            switch response.result {
                case .success(let d):
                    guard let data = d else {
                        print("PGNetwork::uploadImage(image:success:fail:) -> data is nil.")
                        return
                    }
                    success?(self.getImageUrl(from: data))
                case .failure(let e):
                    if let failClosure = fail {
                        failClosure(e)
                    } else {
                        self.presentNetworkAlert()
                    }
            }
        }
    }
    
    public func signIn(url: URL, parameter: Parameter, success: @escaping ((Data?) -> Void)) {
        print(url)
        
        startIndicator()
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: self.headers).response { response in
            self.stopIndicator()
            switch response.result {
            case .success(let d):
                d?.log()
                let code = response.response?.statusCode
                
                if code == 401 {
                    let alert = PGAlertPresentor()
                    alert.present(title: "??????", context: "????????? ?????? ??????????????? ???????????? ????????????.")
                } else {
                    self.processByStatusCode(code: code) {
                        success(d)
                    }
                }
            case .failure(_):
                self.presentNetworkAlert()
            }
        }
    }
    
    public func checkUsernameDuplicate(userType: UserType, username: String, complete: @escaping ((Bool) -> Void)) {
        let url = (userType == .teacher ? PGURLs.teachers : PGURLs.students)
            .appendingURL([username, "exists"])
        
        struct State: Decodable {
            var exists: Bool
        }
        
        print(url)
        startIndicator()
        AF.request(url).response { response in
            self.stopIndicator()
            switch response.result {
            case .success(let d):
                d?.log()
                let code = response.response?.statusCode
                
                self.processByStatusCode(code: code) {
                    guard let receivedData = try? d?.toObject(type: State.self) else {
                        print("PGNetwork::checkUsernameDuplicate() -> decode object error!")
                        return
                    }
                    complete(receivedData.exists)
                }
            case .failure(_):
                self.presentNetworkAlert()
            }
        }
    }
    
    // MARK: - Private Methods
    private enum ErrorStatusCode: Int {
        case badRequest = 400
        case unauthorized = 401
        case forbidden = 403
        case notFound = 404
        case conflict = 409
    }
    
    private func getImageUrl(from data: Data) -> String {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
            if let dictionary = json as? [String : Any] {
                if let dataDictionary = dictionary["data"] as? [String : Any] {
                    if let url = dataDictionary["url"] as? String {
                        return url
                    }
                }
            }
        } catch {
            print("PGNetwork::getImageUrl(from:) -> Cannot convert data to json.")
            return ""
        }
        return ""
    }
    
    private func processByStatusCode(code: Int?, success: (() -> Void)? = nil) {
        guard let statusCode = code else {
            self.presentUnknownErrorAlert()
            return
        }
        
        if (200 ..< 300).contains(statusCode) {
            // ?????? ??? ?????? ??????
            success?()
        } else if (400 ..< 500).contains(statusCode) {
            // ?????? ??????
            guard let status = ErrorStatusCode(rawValue: statusCode) else {
                self.presentUnknownErrorAlert()
                return
            }
            self.handleRequestError(status: status)
        } else if (500 ..< 600).contains(statusCode) {
            // ?????? ??????
            self.presentNetworkAlert()
        }
    }
    
    private func handleRequestError(status: ErrorStatusCode) {
        let alert = PGAlertPresentor()
        var message = ""
        
        // ???????????? ??????
        switch status {
        case .badRequest:
            message = "400 Bad Request"
        case .conflict:
            message = "409 Conflict"
        case .forbidden:
            message = "403 Forbidden"
        case .notFound:
            message = "404 Not Found"
        case .unauthorized:
            message = "401 Unauthorized"
        }
        
        alert.present(title: "??????", context: message)
    }
    
    private func presentNetworkAlert() {
        let alert = PGAlertPresentor()
        alert.presentNetworkError()
    }
    
    private func presentUnauthorizedAlert() {
        let alert = PGAlertPresentor()
        alert.present(title: "??????", context: "????????? ????????? ?????????????????????. ?????? ????????? ??? ????????? ??????????????????!") { handler in
            // ????????? ???????????? ????????????
        }
    }
    
    private func presentUnknownErrorAlert() {
        let alert = PGAlertPresentor()
        alert.present(title: "??????", context: .unknownError)
    }
}

extension Data {
    func log() {
        guard let description = String(data: self, encoding: .utf8) else {
            print("Data is nil.")
            return
        }
        
        print("\n" + description + "\n")
    }
    
    func toObject<T: Decodable>(_ decoder: JSONDecoder = JSONDecoder(), type: T.Type) throws -> T {        
        guard let decoded = try? decoder.decode(type, from: self) else {
            print("Decode Object Error!")
            throw PGError.DecodeError
        }
        
        return decoded
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
        
        var defaultItems = components.queryItems ?? []
        
        for item in items {
            defaultItems.append(item)
        }
        components.queryItems = defaultItems
        
        return components.url!
    }
    
    public func pagination(page: Int, size: Int = 20) -> URL {
        let sizeQuery = URLQueryItem(name: "size", value: String(size))
        let pageQuery = URLQueryItem(name: "page", value: String(page))
        return self.appendingQuery([sizeQuery, pageQuery])
    }
}

extension UIApplication {
    public var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        
        return nil
    }
}
