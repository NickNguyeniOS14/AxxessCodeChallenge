//
//  AxxessTests.swift
//  AxxessTests
//
//  Created by Nick Nguyen on 3/19/21.
//


import XCTest
@testable import Axxess

class AxxessTests: XCTestCase {

    let itemStore = ItemStore()

    // Should use mocking to test network request in production.
    
    func testForSomeResults() {

        itemStore.getItems { (result) in
            switch result {
                case .success(let items):
                    XCTAssertTrue(items.count > 0)
                    XCTAssertEqual(items.count, 34)
                case .failure(let error):
                    XCTAssertNotNil(error)
            }
        }
    }
}
