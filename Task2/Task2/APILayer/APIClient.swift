//
//  APIClient.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation

/// A testable protocol for the API cleint which forse any cleint to have corenetwork object in it.
protocol APIClient {
    var networkClient: NetworkClientType { get }
}

