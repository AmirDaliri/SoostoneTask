//
//  NetworkError.swift
//  SoostoneTask
//
//  Created by Amir Daliri on 13.01.2024.
//

import Foundation

// Enumeration defining various types of network errors.
// This enumeration provides a comprehensive list of errors that could occur during network operations, aiding in debugging and error handling.
enum NetworkError: Error, Equatable {
    // Represents a scenario where the URL is invalid.
    case invalidURL
    
    // An underlying system-level error, encapsulated within this enum.
    // This could represent various errors thrown by networking APIs.
    case underlyingError(Error)
    
    // Indicates that the server's response was invalid or unexpected.
    case invalidResponse
    
    // Indicates the absence of data in the server's response.
    case noData
    
    // Represents an error in decoding the data into the desired format or model.
    // For instance, when JSON decoding fails due to mismatched data types.
    case decodingError(Error)
    
    // Indicates that the requested resource was not found on the server.
    case notFound
    
    // Represents other types of errors, allowing for flexibility and extensibility.
    // The associated String value can provide additional context or message for the error.
    case otherError(String)

    // Implementation of the Equatable protocol to allow for comparing network errors.
    // This is particularly useful in testing or when handling error cases.
    static func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        // Simple cases where equality is straightforward.
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse),
             (.noData, .noData),
             (.notFound, .notFound):
            return true
        // Comparing underlying or decoding errors based on their code and domain.
        case (.underlyingError(let a), .underlyingError(let b)),
             (.decodingError(let a), .decodingError(let b)):
            return (a as NSError).code == (b as NSError).code && (a as NSError).domain == (b as NSError).domain
        default:
            return false
        }
    }
}
