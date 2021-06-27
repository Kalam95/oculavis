//
//  PokemonAPI.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation


/// Protocol to make API for Pockomen reated, it is made to achive testability
protocol PokemonAPIType: APIClient {
    func sendPokemonListRequest(count: String) -> PublishSubject<PockemonDataResponse>
}

/// Class for Pockomen reated API and confirms the protocol mentioned above
class PokemonAPI: PokemonAPIType {

    let networkClient: NetworkClientType

    init(networkClient: NetworkClientType) {
        self.networkClient = networkClient
    }

    func sendPokemonListRequest(count: String) -> PublishSubject<PockemonDataResponse> {
        networkClient.getRequest(path: APIEndPoints.pokemon.rawValue , parameters: [APIKey.limit.rawValue :count])
    }
}
