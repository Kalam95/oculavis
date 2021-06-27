//
//  Encodable+Conversions.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation
extension Encodable {
    public func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)

        return jsonObject.flatMap { $0 as? [String: Any] } ?? [:]

    }

    public func toData() -> Data? {
        try? JSONSerialization.data(withJSONObject: self.toDictionary(), options: .prettyPrinted)
    }
}
