//
//  GeneralTests.swift
//  MacMagazineTests
//
//  Created by Cassio Rossi on 16/10/20.
//  Copyright © 2020 MacMagazine. All rights reserved.
//

import XCTest
@testable import MacMagazine

class GeneralTests: XCTestCase {

    func testIsMigrationDate() {
        XCTAssertEqual(API.APIParams.isMigrationdate, false)
    }

    func testIsNewURL() {
        XCTAssertEqual(API.APIParams.mmDomain, "macmagazine.uol.com.br")
    }

}
