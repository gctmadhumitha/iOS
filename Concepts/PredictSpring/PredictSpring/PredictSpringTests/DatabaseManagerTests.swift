//
//  DatabaseManagerTests.swift
//  PredictSpringTests
//
//  Created by Madhumitha Loganathan on 07/11/23.
//


import XCTest

@testable import PredictSpring
final class DatabaseManagerTests: XCTestCase {
    
    func test_UnitTestDatabaseTask_invalid() {
        let isDatabaseSaveComplete = UserDefaults.standard.bool(forKey: Constants.isDatabaseSaveComplete)
        if (isDatabaseSaveComplete){
            let products = DatabaseManager().fetchProducts(withId: "99", isNewSearch: true)
            print("products ", products)
            XCTAssertNotNil(products)
            XCTAssertGreaterThan(products!.count, 0)
        }
    }
    
    
}
