//
//  File.swift
//  Task2
//
//  Created by mehboob Alam.
//

import Foundation

class ListViewModel {
    private let apiCleint: PokemonAPIType
    private var data: PockemonDataResponse?
    private var filteredList: [Pokemon]?
    private var count: Int
    let signal: PublishSubject<Void>
    private var holder: PublishSubject<PockemonDataResponse>?

    init(apiCleint: PokemonAPIType, count: Int) {
        self.apiCleint = apiCleint
        self.count = count
        self.signal = PublishSubject<Void>()
    }

    deinit {
        holder = nil
    }

    func sendRequest() {
        holder = apiCleint.sendPokemonListRequest(count: count.description)
        holder?.subscribe { [weak self] data in
            self?.data = data
            self?.filteredList = data.results
            DispatchQueue.main.async {[weak self] in
                self?.signal.onNext(())
            }
        } onError: { [weak self] error in
            DispatchQueue.main.async {[weak self] in
                self?.signal.onError(error)
            }
        }
    }

    func filterResult(searchText: String) {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if searchText.isEmpty {
            self.filteredList = data?.results
            return
        }
        self.filteredList = data?.results?.filter({ $0.name?.lowercased().contains(searchText) ?? false })
    }

    //MARK:- Representable Data
    func countString() -> String {
        var string = data?.results?.count.description ?? ""
        if let count  = data?.count, count > 0 {
            string += " out of \(count)"
        }
        return "Total: " + string
    }

    //MARK:- Data source for table view
    func numberOfSection() -> Int {
        return 1
    }

    func numberOfRows(in section: Int) -> Int {
        return filteredList?.count ?? 0
    }

    func data(forRowAt indexPath: IndexPath) -> Pokemon? {
        // NOTE** Since, Pokemon is a Struct(value type), it passing directly will not break MVVM.
        return filteredList?[indexPath.row]
    }
}
