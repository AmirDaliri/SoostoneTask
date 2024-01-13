//
//  MockNetworkService.swift
//  SoostoneTaskTests
//
//  Created by Amir Daliri on 13.01.2024.
//

import Combine
import Foundation
@testable import SoostoneTask

/**
 A mock implementation of the `NetworkServiceProtocol` for testing purposes.

 This class provides a mock network service that can be used for testing network-related functionality in the application. It allows you to simulate different network responses and errors to ensure proper handling by other components.

 ## Usage Example:
 ```swift
 // Create an instance of the `MockNetworkService` with custom result values.
 let mockService = MockNetworkService(
     pokemonsResult: .success(Pokemons(arrayLiteral: Pokemon(id: 2, name: "test", description: "test", imageURL: nil))),
     errorResponse: nil
 )

 // Use the `mockService` for testing network-related functionality.
 */
class MockNetworkService: NetworkServiceProtocol {
    // Properties to customize the mock responses
    var pokemonsResult: Result<Pokemons, NetworkError>
    var errorResponse: ErrorResponse?
    
    /**
     Initializes the `MockNetworkService` with custom result values.

     - Parameters:
        - pokemonsResult: The result for fetching a list of Pokémon.
        - errorResponse: An optional error response to simulate network errors.
     */
    init(
        pokemonsResult: Result<Pokemons, NetworkError> = .success(Pokemons.init(arrayLiteral: Pokemon.init(id: 2, name: "test", description: "test", imageURL: nil))),
        errorResponse: ErrorResponse? = nil
    ) {
        self.pokemonsResult = pokemonsResult
        self.errorResponse = errorResponse
    }

    /**
     Simulates fetching a list of Pokémon.

     - Returns: A publisher that emits the result of fetching Pokémon.
     */
    func fetchPokemons() -> AnyPublisher<Pokemons, NetworkError> {
        // Implementation simulating the network request and response.
        return Future<Pokemons, NetworkError> { promise in
            if let errorResponse = self.errorResponse {
                promise(.failure(errorResponse.toNetworkError()))
            } else {
                switch self.pokemonsResult {
                case .success(let pokemons):
                    promise(.success(pokemons))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

