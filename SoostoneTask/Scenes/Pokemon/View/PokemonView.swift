//
//  PokemonView.swift
//  SoostoneTask
//
//  Created by Amir Daliri on 14.01.2024.
//

import SwiftUI

struct PokemonView: View {
    
    @StateObject var viewModel: PokemonViewModel
    
    var body: some View {
        VStack {
            pokemonImageView
                .frame(height: 120)
                .padding(.top)
            
            Text(viewModel.pokemon.description)
                .font(.body)
                .padding(.horizontal, 32)
            
            Spacer()
        }
        .navigationTitle(viewModel.pokemon.name)
        .accessibilityIdentifier("PokemonView") // Set the accessibility identifier
    }
    
    private var pokemonImageView: some View {
        Image(uiImage: viewModel.pokemon.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    PokemonView(viewModel: PokemonViewModel(pokemon: .init(id: 1, name: "Bulbasaur", description: "There is a plant seed on its back right from the day this Pokémon is born. The seed slowly grows larger.", image: #imageLiteral(resourceName: "pokemon_placeholder"))))
}
