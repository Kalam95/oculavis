//
//  ListViewModel.swift
//  SwiftUITASK2
//
//  Created by mehboob Alam on 28/06/21.
//

import Foundation
import Combine

class PokemonListViewModel: ObservableObject {
    private let apiCleint: PokemonAPIType
    private var data: PockemonDataResponse?
    @Published var filteredList: [Pokemon]
    private var count: Int
    private var cancellable: AnyCancellable?

    init(apiCleint: PokemonAPIType, count: Int) {
        self.apiCleint = apiCleint
        self.count = count
        filteredList = []
        count > 0 ? sendRequest() : nil
    }

    func sendRequest() {
        cancellable = apiCleint.sendPokemonListRequest(count: count.description).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] respnse in
                self?.data = respnse
                self?.filteredList = respnse.results ?? []
            })
    }

    func filterResult(searchText: String) {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if searchText.isEmpty {
            self.filteredList = data?.results ?? []
            return
        }
        self.filteredList = data?.results?.filter({ $0.name?.lowercased().contains(searchText) ?? false }) ?? []
    }
}
