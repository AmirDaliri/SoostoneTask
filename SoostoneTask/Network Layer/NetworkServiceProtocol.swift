//
//  NetworkServiceProtocol.swift
//  SoostoneTask
//
//  Created by Amir Daliri on 13.01.2024.
//

import Combine

/// Protocol defining the requirements for a network service in the application.
/// This protocol ensures that any network service class conforms to a standard interface for fetching Pokémon data.
protocol NetworkServiceProtocol {
    /// Function to fetch a list of Pokémon.
    /// - Returns: A publisher that emits a `Pokemons` object (containing multiple Pokémon instances) or a `NetworkError`. The use of `AnyPublisher` allows for flexibility in the underlying implementation, making the protocol adaptable to different networking strategies.
    func fetchPokemons() -> AnyPublisher<Pokemons, NetworkError>
}
