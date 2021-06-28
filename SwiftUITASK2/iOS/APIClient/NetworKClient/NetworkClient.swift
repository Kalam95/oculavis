//
//  NetworkClient.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation
import Combine

/***
 Its a Protocol, providing the standared for the Newtork call, it contains methods for most common apis request/method types. This protocal makes the Network layer testable.
 */
public protocol NetworkClientType {
    func getRequest<ResponseType: Decodable>(path: String, parameters: [String: String]) -> AnyPublisher<ResponseType, HTTPNetworkError>

//    func postRequest<ResponseType: Decodable>(path: String, body: Encodable) -> PublishSubject<ResponseType>
//
//    func putRequest<ResponseType: Decodable>(path: String, body: Encodable) -> PublishSubject<ResponseType>
//
//    func deleteRequest<ResponseType: Decodable>(path: String, parameters: [String: String]) -> PublishSubject<ResponseType>
}

/**
 Network class conferming all the network mothds for all HTTPs request types
 - It is generic isn nature, but restricted to the Decodable types.
 - **Note:** It uses URL session and data task for that, Websocke can also be used.
*/
public class NetworkClient: NSObject, NetworkClientType {

    var task: URLSessionTask?
    let baseUrl: String
    var headers: [String: String] = [:]
    var session: URLSession?

    public func getRequest<ResponseType: Decodable>(path: String, parameters: [String: String]) -> AnyPublisher<ResponseType, HTTPNetworkError>  {
        sendRequest(request: buildRequest(path: path, urlParameters: parameters ))
    }

//    public func postRequest<ResponseType: Decodable>(path: String, body: Encodable) -> PublishSubject<ResponseType> {
//        sendRequest(request: buildRequest(path: path, httpMethod: .post, body: body))
//    }
//
//    public func putRequest<ResponseType: Decodable>(path: String, body: Encodable) -> PublishSubject<ResponseType> {
//        sendRequest(request: buildRequest(path: path, httpMethod: .put, body: body))
//    }
//
//    public func deleteRequest<ResponseType: Decodable>(path: String, parameters: [String: String]) -> PublishSubject<ResponseType> {
//        sendRequest(request: buildRequest(path: path, httpMethod: .delete, urlParameters: parameters))
//    }
    
    /// Method to send request using URL session, This methods sends the request and parse the data,
    /// and in case of error it reports it exactly.
    /// - Note: 1. Its a generic function.
    /// - Parameter request: URLrequest coanting, body of the request, headers, urls etcs
    /// - Returns: the response Observer(publisher), whoich will emit value[api data] or error on the bases of api completion status.
    public func sendRequest<ResponseType: Decodable>(request: URLRequest) -> AnyPublisher<ResponseType, HTTPNetworkError> {
        if session == nil {
            session = URLSession.shared
        }

//        let responseSubject = PublishSubject<ResponseType>()
        NetworkLogger.log(request: request)
        return session!.dataTaskPublisher(for: request).tryMap({ response -> ResponseType in
            let result = HTTPNetworkResponse.handleNetworkResponse(for: response.response,
                                                                   data: response.data)
            switch result {
            case .success:
                return try JSONDecoder().decode(ResponseType.self, from: response.data)
            default:
                throw result
            }
        }).mapError({
            return $0 as? HTTPNetworkError ?? .couldNotParse
        }).eraseToAnyPublisher()
    }

    
    /// Method to create the api Request
    /// - Parameters:
    ///   - path: url path for the server
    ///   - httpMethod: type of request, get or post or any other
    ///   - urlParameters: if url parameters are qured such as query
    ///   - body: body of the HTTP request(jOSON request data object)
    /// - Returns:URL request from the passed parameters
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

    
    /// If required, then we can cancel the on coing request suing this.
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
