//
//  AxxessUITests.swift
//  AxxessUITests
//
//  Created by Nick Nguyen on 3/19/21.
//

import XCTest

class AxxessUITests: XCTestCase {

    private var app: XCUIApplication!

    private var firstTableCell: XCUIElement {
        return app.tables.element(boundBy: 0)
    }

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app = XCUIApplication()

        app.launchArguments = ["UITesting"]
        app.launch()
    }

    func testFirstLaunch() {
        XCTAssertTrue(app.navigationBars.staticTexts["Axxess"].exists)
        XCTAssertTrue(firstTableCell.exists)
    }
}
