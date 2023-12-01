//
//  MacMagazineUITests.swift
//  MacMagazineUITests
//
//  Created by Cassio Rossi on 01/12/2023.
//

import XCTest

final class MacMagazineUITests: XCTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
}
