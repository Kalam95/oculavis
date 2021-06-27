//
//  NetworkLogger.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation

/// Class to log network calls and reqpose
public class NetworkLogger {

    
    ///  check should log network calls or not
    private static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    
    /// Methdo to log request and its parameters in a easy to read format
    /// - Parameter request: request to be printed
    static func log(request: URLRequest) {
        if NetworkLogger.isLoggingEnabled {
        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }

        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)

        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"

        var logOutput = """
                        \(urlAsString) \n\n
                        \(method) \(path)?\(query) HTTP/1.1 \n
                        HOST: \(host)\n
                        """
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }

        print(logOutput)
    }
}

    /// Methdo to log API response and its parameters in a easy to read format
    /// - Parameter request: response or data to be printed
    static func log(response: HTTPURLResponse, data: Data?) {
        if NetworkLogger.isLoggingEnabled {
        print("\n-----------------Response start------------------\n")
        print("status code: \(response.statusCode) \n")
        print((try? JSONSerialization.jsonObject(with: data ?? Data.init(), options: [])) ?? "Data could not be serialized")
        }
    }

    
    /// Method to log erros
    /// - Parameter error: error to be printed
    static func log(error: Error?) {
        if NetworkLogger.isLoggingEnabled {
        print("\n-----------------Response start------------------\n")
            print(error ?? "unable to print error")
        }
    }
}
