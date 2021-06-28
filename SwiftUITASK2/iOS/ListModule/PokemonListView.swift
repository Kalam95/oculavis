//
//  PokemonListView.swift
//  SwiftUITASK2
//
//  Created by mehboob Alam on 28/06/21.
//

import SwiftUI
import Combine
import UIKit

struct PokemonListView: View {
    
    @ObservedObject var viewModel: PokemonListViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30, content: {
            List(viewModel.filteredList) { pokemon in
                VStack (alignment: .leading, spacing: 10) {
                    HStack(alignment: .center, spacing: 20, content: {
                        AsyncImage(url: URL(string: pokemon.imageURl ?? "")!,
                                   placeholder: { Text("Loading ...") },
                                   image: { Image(uiImage: $0).resizable() })
                            .aspectRatio(contentMode: .fit)
                            .border(Color.black, width: 1)
                            .frame(width: 100, height: 100, alignment: .leading).padding()
                        Text(pokemon.name ?? "N/A").font(.headline).padding()
                    })
                    Text("Details at: \(pokemon.url ?? "N/A")").font(.caption2)
                }
            }
        }).navigationBarTitle(Text("Pokemon"))

    }
}
