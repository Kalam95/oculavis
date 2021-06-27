//
//  PokemonAPI.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation

protocol PokemonAPIType: APIClient {
    func sendPokemonListRequest(count: String) -> PublishSubject<PockemonDataResponse>
}

class PokemonAPI: PokemonAPIType {

    let networkClient: NetworkClientType

    init(networkClient: NetworkClientType) {
        self.networkClient = networkClient
    }

    func sendPokemonListRequest(count: String) -> PublishSubject<PockemonDataResponse> {
        networkClient.getRequest(path: APIEndPoints.pokemon.rawValue , parameters: [APIKey.limit.rawValue :count])
    }
}
