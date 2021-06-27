//
//  Pockemon.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation

struct PockemonDataResponse: Codable {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [Pokemon]?
}

struct Pokemon: Codable {
    var name: String?
    var url: String?
    var imageURl: String? {
        guard let name = name else { return nil }
        return AppURL.imageDownload.rawValue + "\(name).png"
    }
}
