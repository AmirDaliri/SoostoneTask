//
//  PokemonViewModel.swift
//  SoostoneTask
//
//  Created by Amir Daliri on 14.01.2024.
//

import Foundation
import Combine
import SwiftUI

// ViewModel for managing and presenting details of a specific pokemon.
class PokemonViewModel: ObservableObject {
    
    @Published var pokemon: PokemonUIModel // The pokemon whose details are being shown.

    init(pokemon: PokemonUIModel) {
        self.pokemon = pokemon
    }
}
