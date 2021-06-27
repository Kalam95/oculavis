//
//  SSLHandler.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation

public final class SSLHandler {
    static private func didReceive(serverTrustChallenge challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let customRoot = Bundle.main.certificate(named: "Cert Name") //TODO: Enter name
        let trust = challenge.protectionSpace.serverTrust!
        if trust.evaluateAllowing(rootCertificates: [customRoot]) {
            completionHandler(.useCredential, URLCredential(trust: trust))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

    static private func didReceive(clientIdentityChallenge challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let password = "Password" //TODO: Enter Password
        let identity = Bundle.main.identity(named: "p12 Name"/*TODO: Enter P12 name*/, password: password)
        completionHandler(.useCredential, URLCredential(identity: identity, certificates: nil, persistence: .forSession))
    }

    static func didReceive(challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        let host = "Host name"
        switch (challenge.protectionSpace.authenticationMethod, challenge.protectionSpace.host) {
        case (NSURLAuthenticationMethodServerTrust, host):
            didReceive(serverTrustChallenge: challenge, completionHandler: completionHandler)
        case (NSURLAuthenticationMethodClientCertificate, host):
            didReceive(clientIdentityChallenge: challenge, completionHandler: completionHandler)
        default:
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

extension Bundle {

    func certificate(named name: String) -> SecCertificate {
        let cerURL = self.url(forResource: name, withExtension: "cer")!
        guard let cerData = try? Data(contentsOf: cerURL) else { fatalError() }
        let cer = SecCertificateCreateWithData(nil, cerData as CFData)!
        return cer
    }

    // swiftlint:disable force_cast
    func identity(named name: String, password: String) -> SecIdentity {
        let p12URL = self.url(forResource: name, withExtension: "p12")!
        guard let p12Data = try? Data(contentsOf: p12URL) else { fatalError() }

        var importedCF: CFArray?
        let options = [kSecImportExportPassphrase as String: password]
        let err = SecPKCS12Import(p12Data as CFData, options as CFDictionary, &importedCF)
        precondition(err == errSecSuccess)
        guard let imported = importedCF! as NSArray as? [[String: AnyObject]] else { fatalError() }
        precondition(imported.count == 1)

        return (imported[0][kSecImportItemIdentity as String]!) as! SecIdentity
    }
    // swiftlint:enable force_cast
}

extension SecTrust {

    func evaluate() -> Bool {
        var trustResult: SecTrustResultType = .invalid
        var err = SecTrustEvaluate(self, &trustResult)
        guard err == errSecSuccess else { return false }

        if trustResult == .recoverableTrustFailure {
            let errDataRef: CFData = SecTrustCopyExceptions(self)
            SecTrustSetExceptions(self, errDataRef)
            err = SecTrustEvaluate(self, &trustResult)
        }

        return [.proceed, .unspecified].contains(trustResult)
    }

    func evaluateAllowing(rootCertificates: [SecCertificate]) -> Bool {

        // Apply our custom root to the trust object.
        var err = SecTrustSetAnchorCertificates(self, rootCertificates as CFArray)
        guard err == errSecSuccess else { return false }

        // Re-enable the system's built-in root certificates.
        err = SecTrustSetAnchorCertificatesOnly(self, false)
        guard err == errSecSuccess else { return false }

        // Run a trust evaluation and only allow the connection if it succeeds.
        return self.evaluate()
    }
}
