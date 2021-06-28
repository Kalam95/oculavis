//
//  ContentView.swift
//  Shared
//
//  Created by mehboob Alam on 28/06/21.
//

import SwiftUI

// Simple onbaording View
struct ContentView: View {
    @State var count = ""
    @State var push: Bool = false
    var body: some View {
        NavigationView(content: {
            VStack {
                Form{
                    Section {
                        Text("Enter the number of pokemon you would like to hit")
                            .padding()
                        TextField("Number Value", text: $count)
                            .padding()
                    }
                    Section {
                        Button("Continue", action: {
                            self.push = true
                        })
                        .disabled(Int(count) == nil)
                        .padding()
                    }
                }
                NavigationLink("Show",
                               destination: PokemonListView(viewModel: PokemonListViewModel(apiCleint:
                                                                                                PokemonAPI(networkClient:
                                                                                                            NetworkClient(baseUrl: AppURL.base.rawValue)),
                                                                                             count: Int(count) ?? 0)),
                               isActive: $push).hidden()
            }.navigationTitle("Start")
        })

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
