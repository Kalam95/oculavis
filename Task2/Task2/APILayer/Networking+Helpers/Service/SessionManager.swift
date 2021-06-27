//
//  SessionManager.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation

public final class SessionManager {
    var sessionID: String?
    var formID: String?
    var lastModified: Date?

    static let shared = SessionManager()

    let lastModifiedKey = "x-headers-last-modified"
    let sessionIDKey = "x-session-id"
    let formIDKey = "x-form-id"

    private init() {}

    func clear() {
        sessionID = nil
        formID = nil
        lastModified = nil
    }

    func updateHeaderData(_ headers: [AnyHashable: Any]) {
        if let headerDict = headers as? [String: String],
           let sessionIDResponse = headerDict[sessionIDKey],
           let formIDResponse = headerDict[formIDKey] {
            sessionID = sessionIDResponse
            formID = formIDResponse
        }
    }

    func getHeaderData() -> [String: String] {
        var headerDict: [String: String] = [:]

        if let sessionID = sessionID,
           let formID = formID {
            headerDict[sessionIDKey] = sessionID
            headerDict[formIDKey] = formID
        }
        return headerDict
    }
}
