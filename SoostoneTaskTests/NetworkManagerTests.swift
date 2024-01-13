//
//  NetworkManagerTests.swift
//  SoostoneTaskTests
//
//  Created by Amir Daliri on 13.01.2024.
//

import XCTest
import Combine
@testable import SoostoneTask

class NetworkManagerTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testNetworkLayerHandles404Error() {
        
        // Given: An error response and a mock network service configured to return that error
        let errorResponse = ErrorResponse(detail: "404: Not Found")
        let mockNetworkService = MockNetworkService(pokemonsResult: .failure(.notFound), errorResponse: errorResponse)
        
        
        let expectation = XCTestExpectation(description: "Network service handles 404 error")
        
        // When: Fetching Pokémon data
        let cancellable = mockNetworkService.fetchPokemons()
            .sink(receiveCompletion: { completion in
                if case let .failure(networkError) = completion {
                    switch networkError {
                    case .notFound:
                        expectation.fulfill()
                    default:
                        XCTFail("Expected .notFound error, but got \(networkError)")
                    }
                } else {
                    XCTFail("Expected NetworkError, but got different type")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but received value")
            })
        
        // Wait for the expectation to be fulfilled, or timeout
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
    }

    func testNetworkErrorReturnsDetailMessage() {
        // Given: An error response and a mock network service configured to return that error
        let detailMessage = "404: Not Found"
        let errorResponse = ErrorResponse(detail: detailMessage)
        let mockNetworkService = MockNetworkService(pokemonsResult: .failure(.underlyingError(errorResponse)), errorResponse: errorResponse)

        let expectation = XCTestExpectation(description: "Network service returns detailed error message")

        // When: Fetching Pokemons
        let cancellable = mockNetworkService.fetchPokemons()
            .sink(receiveCompletion: { completion in
                if case let .failure(networkError) = completion {
                    switch networkError {
                    case .notFound:
                        expectation.fulfill()
                    default:
                        XCTFail("Expected .notFound error, but got \(networkError)")
                    }
                } else {
                    XCTFail("Expected NetworkError, but got different type")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but received value")
            })        // Wait for the expectation to be fulfilled, or timeout
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
    }

    func testInvalidURLError() {
        // Given: A mock network service configured to return an invalidURL error
        let mockNetworkService = MockNetworkService(pokemonsResult: .failure(.invalidURL))

        let expectation = XCTestExpectation(description: "Invalid URL error handling")

        // When: Fetching pokemons
        let cancellable = mockNetworkService.fetchPokemons()
            .sink(receiveCompletion: { completion in
                // Then: Check if the error returned is an invalidURL error
                if case .failure(let error) = completion, error == .invalidURL {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected invalidURL error, but got different type")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but received value")
            })

        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
    }

    
    func testNetworkLayerErrorHandling() {
        // Given: Setup the mock network service to return a 404 error
        let service = MockNetworkService(pokemonsResult: .failure(.invalidResponse))
        let expectation = XCTestExpectation(description: "Network error handling")

        // When: Making a request that should trigger a 404 error
        service.fetchPokemons()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    // Then: Assert that a 404 error is correctly identified and handled
                    if error == .invalidResponse {
                        expectation.fulfill()
                    }
                default:
                    break
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        // Wait for the expectation to be fulfilled, or timeout
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchPokemonsFailure() {
        // Set up the mock network service to simulate a failure response
        let service = MockNetworkService(pokemonsResult: .failure(.invalidResponse))
        let expectation = XCTestExpectation(description: "Fetch Pokemons failure")
        
        // Perform the network request using the mock service
        service.fetchPokemons()
            .sink(receiveCompletion: { completion in
                // Check if the completion block receives the correct failure type
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, NetworkError.invalidResponse)
                    expectation.fulfill() // Fulfill the expectation upon successful assertion
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        // Wait for the test expectations to be fulfilled or time out
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchPokemonsSuccessEmptyList() {
        // Given: Setup the mock network service to return a successful response with an empty pokemons list
        let mockPokemon: Pokemons = []
        
        let service = MockNetworkService(pokemonsResult: .success(mockPokemon))
        let expectation = XCTestExpectation(description: "Fetch Pokemons successfully with empty list")

        // When: Fetch Pokemons using the mock network service
        service.fetchPokemons()
            .sink(receiveCompletion: { _ in }, receiveValue: { pokemon in
                // Then: Verify that the results array is empty as expected
                XCTAssertTrue(pokemon.isEmpty)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        // Wait for the expectation to be fulfilled, or timeout
        wait(for: [expectation], timeout: 1.0)
    }


    func testFetchPokemonsNetworkError() {
        // Given: Setup the mock network service to simulate a network error
        let service = MockNetworkService(pokemonsResult: .failure(.underlyingError(DummyError())))
        let expectation = XCTestExpectation(description: "Network error while fetching Pokemons")

        // When: Fetch Pokemons using the mock network service
        service.fetchPokemons()
            .sink(receiveCompletion: { completion in
                // Then: Check if the completion block receives a failure with an underlying error
                if case .failure(let error) = completion, case .underlyingError(_) = error {
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        // Wait for the expectation to be fulfilled, or timeout
        wait(for: [expectation], timeout: 1.0)
    }
}
