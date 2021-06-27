//
//  NetworkClient.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation

public protocol NetworkClientType {
    func getRequest<ResponseType: Decodable>(path: String, parameters: [String: String]) -> PublishSubject<ResponseType>

    func postRequest<ResponseType: Decodable>(path: String, body: Encodable) -> PublishSubject<ResponseType>

    func putRequest<ResponseType: Decodable>(path: String, body: Encodable) -> PublishSubject<ResponseType>

    func deleteRequest<ResponseType: Decodable>(path: String, parameters: [String: String]) -> PublishSubject<ResponseType>
}

public class NetworkClient: NSObject, NetworkClientType {

    var task: URLSessionTask?
    let baseUrl: String
    var headers: [String: String] = [:]
    var session: URLSession?

    public func getRequest<ResponseType: Decodable>(path: String, parameters: [String: String]) -> PublishSubject<ResponseType> {
        sendRequest(request: buildRequest(path: path, urlParameters: parameters ))
    }

    public func postRequest<ResponseType: Decodable>(path: String, body: Encodable) -> PublishSubject<ResponseType> {
        sendRequest(request: buildRequest(path: path, httpMethod: .post, body: body))
    }

    public func putRequest<ResponseType: Decodable>(path: String, body: Encodable) -> PublishSubject<ResponseType> {
        sendRequest(request: buildRequest(path: path, httpMethod: .put, body: body))
    }

    public func deleteRequest<ResponseType: Decodable>(path: String, parameters: [String: String]) -> PublishSubject<ResponseType> {
        sendRequest(request: buildRequest(path: path, httpMethod: .delete, urlParameters: parameters))
    }

    public func sendRequest<ResponseType: Decodable>(request: URLRequest) -> PublishSubject<ResponseType> {
        if session == nil {
            session = URLSession.shared
        }

        let responseSubject = PublishSubject<ResponseType>()
        NetworkLogger.log(request: request)
        task = session!.dataTask(with: request, completionHandler: { [weak responseSubject] data, response, error in
            guard let responseSubject = responseSubject else { return }
            if error != nil {
                if let noInternetError = error as NSError?,
                   noInternetError.code == NSURLErrorNotConnectedToInternet,
                   noInternetError.domain == NSURLErrorDomain {
                    responseSubject.onError(HTTPNetworkError.noInternetConnection)
                    NetworkLogger.log(error: error)
                    return
                }
                responseSubject.onError(HTTPNetworkError.other(error!.localizedDescription))
                NetworkLogger.log(error: error)
                return
            }

            if let response = response as? HTTPURLResponse {
                NetworkLogger.log(response: response, data: data)
                let result = HTTPNetworkResponse.handleNetworkResponse(for: response, data: data)
                switch result {
                case .success:
                    guard let responseData = data else {
                        responseSubject.onError(HTTPNetworkError.noData)
                        return
                    }
                    do {
                        let type = ResponseType.self
                        let apiResponse = try JSONDecoder().decode(type, from: responseData)
                        responseSubject.onNext(apiResponse)
                    } catch {
                        NetworkLogger.log(error: error)
                        responseSubject.onError(HTTPNetworkError.unableToDecode)
                    }
                case .authenticationError:
                    responseSubject.onError(HTTPNetworkError.authenticationError)
                default:
                    NetworkLogger.log(error: error)
                    responseSubject.onError(result)
                }
            }
        })
        self.task?.resume()
        return responseSubject
    }

    private func buildRequest(
        path: String,
        httpMethod: HTTPMethod = .get,
        urlParameters: [String: String] = [:],
        body: Encodable? = nil
    ) -> URLRequest {

        let url = URL(string: self.baseUrl)!.appendingPathComponent(path)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = urlParameters.map {key, value in
            URLQueryItem(name: key,
                         value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        }
        var request = URLRequest(url: (urlComponents?.url!)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body?.toData()

        return request
    }

    public func cancel() {
        self.task?.cancel()
    }

    public init(baseUrl: String, headers: [String: String] = [:]) {
        self.baseUrl = baseUrl
        self.headers["Content-Type"] = "application/json"
        for (key, value) in headers {
            self.headers[key] = value
        }
    }
}

extension NetworkClient: URLSessionDelegate {
//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        SSLHandler.didReceive(challenge: challenge, completionHandler: completionHandler)
//    }
}
