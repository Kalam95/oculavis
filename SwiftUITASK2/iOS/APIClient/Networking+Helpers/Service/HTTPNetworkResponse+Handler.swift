//
//  HTTPNetworkResponse.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation

/// API response handling on the basis of status received by server.
public struct HTTPNetworkResponse {
    static func handleNetworkResponse(for response: URLResponse, data: Data?) -> HTTPNetworkError {
        guard let response = response as? HTTPURLResponse else { return .couldNotParse}
        switch response.statusCode {
        case 200...299: return .success
        case URLError.Code.notConnectedToInternet.rawValue, URLError.Code.networkConnectionLost.rawValue:
            return .noInternetConnection
        case 400...500:
            if let responseData = data {
                do {
                    let errorData = try JSONDecoder().decode(GenericErrorData.self, from: responseData)
                    return HTTPNetworkError.badRequest(errorData)
                } catch {
                    return HTTPNetworkError.unableToDecode
                }
            }
            return HTTPNetworkError.badRequest(nil)
        case 501...599: return HTTPNetworkError.serverSideError
        default: return HTTPNetworkError.failed
        }
    }
}
