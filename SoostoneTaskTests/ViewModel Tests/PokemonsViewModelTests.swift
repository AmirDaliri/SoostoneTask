//
//  PokemonsViewModelTests.swift
//  SoostoneTaskTests
//
//  Created by Amir Daliri on 14.01.2024.
//

import XCTest
import Combine
@testable import SoostoneTask

class PokemonsViewModelTests: XCTestCase {
    
    var viewModel: PokemonsViewModel!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        // Providing a default result for initialization
        let defaultResult: Result<Pokemons, NetworkError> = .success(Pokemons.init(arrayLiteral: .init(id: 1, name: "test", description: "test", imageURL: nil)))
        mockNetworkService = MockNetworkService(pokemonsResult: defaultResult)

        // Ensure that MockNetworkService conforms to NetworkServiceProtocol
        viewModel = PokemonsViewModel(networkService: mockNetworkService)
        
        cancellables = []

    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        cancellables = nil
        super.tearDown()
    }

    func testLoadPokemons_Success() {
        // Given: A successful response from the network service
        let expectedPokemons = Pokemons.init(arrayLiteral: .init(id: 1, name: "test", description: "test", imageURL: nil))
        mockNetworkService.pokemonsResult = .success(expectedPokemons)

        // When: Loading Pokemons
        viewModel.loadPokemons()

        // Then: Pokemons array in view model should be updated
        XCTAssertEqual(viewModel.pokemons, expectedPokemons)
    }

    func testLoadPokemons_Error() {
        // Given: An error response from the network service
        let pokemonError = NetworkError.noData
        mockNetworkService.pokemonsResult = .failure(pokemonError)

        // Expectation for async response
        let expectation = self.expectation(description: "Error handling in view model")
        viewModel.$networkError
            .sink { error in
                if error == pokemonError {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // When: Loading Pokemons
        viewModel.loadPokemons()

        // Then: NetworkError property in view model should be updated
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

