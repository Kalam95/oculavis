//
//  GenericError.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation

///**Note:** I do not know the contract as of now so i just created it to showcase, and hence its not used in thsi app
/// A generic Error response, on the basis of API contract with frontend and server
public struct GenericErrorData: Codable {
    let message: String?
    let status: String?
    let errorCode: String?

    private enum CodingKeys: String, CodingKey {
        case status
        case message
        case errorCode
    }

    public init(message: String?, status: String?, errorCode: String?) {
        self.message = message
        self.status = status
        self.errorCode = errorCode
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        message = try? container.decode(String.self, forKey: .message)
        errorCode = try? container.decode(String.self, forKey: .errorCode)
        if let value = try? container.decode(Int.self, forKey: .status) {
            status = String(value)
        } else {
            status = try? container.decode(String.self, forKey: .status)
        }
    }
}
