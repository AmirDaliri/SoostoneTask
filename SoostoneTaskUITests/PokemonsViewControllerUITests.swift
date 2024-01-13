//
//  PokemonsViewControllerUITests.swift
//  SoostoneTaskUITests
//
//  Created by Amir Daliri on 14.01.2024.
//

import XCTest

class PokemonsViewControllerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testPokemonsViewController() throws {
        let table = app.tables["PokemonsTableView"]

        // Wait for the table to appear
        XCTAssertTrue(table.waitForExistence(timeout: 5))

        // Scroll to the last cell
        let lastCell = table.cells.element(boundBy: table.cells.count - 1)
        XCTAssertTrue(lastCell.waitForExistence(timeout: 5))
        table.swipeUp()

        // Pull to refresh
        let start = lastCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let end = lastCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 6))
        start.press(forDuration: 0, thenDragTo: end)

        // Wait for the data to refresh
        XCTAssertTrue(table.waitForExistence(timeout: 5))
    }
}


