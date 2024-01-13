//
//  TestUtilities.swift
//  SoostoneTaskTests
//
//  Created by Amir Daliri on 13.01.2024.
//

import Foundation

class TestUtilities {
    // A shared instance for easy access to utility functions
    static let shared = TestUtilities()

    private init() {} // Prevent external instantiation

    // Function to load JSON data from a file in the test bundle
    func loadJson(from fileName: String) -> Data? {
        guard let url = Bundle(for: TestUtilities.self).url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        return data
    }

    // You can add more utility functions here as needed
}

// Dummy error for testing
struct DummyError: Error {}
