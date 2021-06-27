//
//  HTTPNetworkError.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation


/** Type of possible erros
 - **NOTE:** In general descriptions should be localised, but as of now it supposts english only.
 */
public enum HTTPNetworkError: Error {
    case success
    case parametersNil
    case headersNil
    case encodingFailed
    case decodingFailed
    case missingURL
    case couldNotParse
    case noData
    case fragmentResponse
    case unwrappingError
    case dataTaskFailed
    case authenticationError
    case badRequest(GenericErrorData?)
    case pageNotFound
    case failed
    case serverSideError
    case unableToDecode
    case noInternetConnection
    case other(String)// can be omitted

    public var errorData: GenericErrorData? {
        switch self {
        case .badRequest(let errorData):
            return errorData
        default:
            return nil
        }
    }

    
    /// Descriptions, for user's understanding.
    public var errorMessage: String {
        switch self {
        case .success:
            return "Successful Network Request"
        case .authenticationError:
            return "Invalid User credentials"
        case .badRequest(let errorData):
            return errorData?.message ?? "Bad Request received"
        case .noInternetConnection:
            return "You are not connected to internet, please check your network connection and try again later"
        case .other(let message):
            return message
        default:
            // rest all are not understandable by user so something went wrong is better
            return "Opps!!! Something went wrong"
        }
    }
}
