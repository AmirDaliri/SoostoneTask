//
//  Router.swift
//  SoostoneTask
//
//  Created by Amir Daliri on 13.01.2024.
//

import Foundation

/// Enum representing the various network endpoints used within the app.
/// It conforms to the Endpoint protocol (assumed) and provides a structured way to manage URL construction for different network requests.
enum Router: Endpoint {
    // Enum cases for each type of network request, such as fetching a list of Pokemon.
    case fetchPokemons

    /// Base URL for the network requests.
    /// Computed property returning the URL object for the base address of the network service.
    var baseUrl: URL {
        return URL(string: "https://gist.githubusercontent.com/DavidCorrado")!
    }
    
    /// Path for the specific endpoint.
    /// Determined based on the enum case and appended to the base URL to form the full URL for a request.
    var path: String {
        switch self {
        case .fetchPokemons:
            // Path specific to fetching a list of Pokemon.
            return "/8912aa29d7c4a5fbf03993b32916d601/raw/681ef0b793ab444f2d81f04f605037fb44814125/pokemon.json"
        }
    }

    /// URLRequest construction for the specific network request.
    /// This computed property constructs and returns a URLRequest object for the given endpoint, combining the base URL with the specific path.
    var urlRequest: URLRequest {
        // Construct the full URL by appending the path to the base URL.
        let url = baseUrl.appendingPathComponent(path)
        // Initialize and return a URLRequest object with the constructed URL.
        return URLRequest(url: url)
    }
}
