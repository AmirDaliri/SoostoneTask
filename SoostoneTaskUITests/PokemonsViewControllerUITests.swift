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
        
    func testShowPullToRefresh() {
        // Swipe down to trigger pull-to-refresh
        app.tables.element.swipeDown()

        // Wait for the refresh to complete
        sleep(2) // Adjust the sleep duration as needed

        // Assert that the Pokemon list is visible
        XCTAssertTrue(app.navigationBars["Pokemons"].exists)
    }
    
    func testScrollToLastCell() {
        // Assuming your table has an accessibility identifier, replace "YourTableIdentifier" with the actual identifier.
        let table = app.tables["PokemonsTableView"]
        // Access the first cell
        let firstCell = table.cells.element(boundBy: 0)
        let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 6))
        finish.press(forDuration: 0, thenDragTo: start, withVelocity: .slow, thenHoldForDuration: 0)

        // Wait for the refresh to complete
        sleep(2) // Adjust the sleep duration as needed

        // Assert that the Pokemon list is visible
        XCTAssertTrue(app.navigationBars["Pokemons"].exists)
    }
    
    func testNavigateToDetail2() throws {
        // Assuming there is at least one cell in the table view
        let firstCell = app.tables["PokemonsTableView"].cells.firstMatch
        firstCell.tap()
        print(app.debugDescription)
        
        // Assert that the detail view is displayed
        XCTAssertTrue(app.staticTexts["PokemonView"].waitForExistence(timeout: 5))
    }
    
    func testNavigateBackToPokemonList() {
        // Tap on the cell
        app.tables.cells.element(boundBy: 0).tap()

        // Tap the back button
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Assert that the Pokemon list is visible
        XCTAssertTrue(app.navigationBars["Pokemons"].exists)
    }

}


