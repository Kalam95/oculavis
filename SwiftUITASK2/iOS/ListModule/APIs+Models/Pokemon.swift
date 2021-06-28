//
//  Pockemon.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation

/// Codable is used for JSOn decodinga nd parsing
/// Data Model for network JSON response
struct PockemonDataResponse: Codable {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [Pokemon]?
}

/// Data Model for network JSON response for Pokemon
struct Pokemon: Codable,Identifiable {
    var id: String { "\(Float.random(in: 0...20000))" }
    var name: String?
    var url: String?
    var imageURl: String? {
        guard let name = name else { return nil }
        return AppURL.imageDownload.rawValue + "\(name).png"
    }
}
