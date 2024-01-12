//
//  NetworkManager.swift
//  SoostoneTask
//
//  Created by Amir Daliri on 13.01.2024.
//

import Foundation
import Combine

/// `NetworkManager` is responsible for managing network requests and data fetching.
class NetworkManager: NetworkServiceProtocol {
    
    /// Fetches a list of Pokémon from the server.
    /// - Returns: A publisher that emits a `Pokemons` object or a `NetworkError`.
    func fetchPokemons() -> AnyPublisher<Pokemons, NetworkError> {
        let request = Router.fetchPokemons.urlRequest

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                // Check for HTTP status code 200, otherwise decode the error response.
                guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: output.data)
                    throw errorResponse.toNetworkError()
                }
                return output.data
            }
            .mapError { error in
                // Convert any thrown errors to `NetworkError`.
                (error as? NetworkError) ?? NetworkError.underlyingError(error)
            }
            .flatMap(maxPublishers: .max(1)) { data in
                // Decode the data into a `Pokemons` object.
                self.decode(data)
            }
            .eraseToAnyPublisher()
    }

    /// Generic helper function for decoding a JSON response into a specified `Decodable` type.
    /// - Parameter data: The data to decode.
    /// - Returns: A publisher that emits a decoded object or a `NetworkError`.
    private func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, NetworkError> {
        Just(data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { NetworkError.decodingError($0) }
            .eraseToAnyPublisher()
    }
}
