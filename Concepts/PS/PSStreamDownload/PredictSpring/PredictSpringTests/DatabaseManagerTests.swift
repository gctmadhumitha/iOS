//
//  DatabaseManagerTests.swift
//  PredictSpringTests
//
//  Created by Madhumitha Loganathan on 07/11/23.
//


import XCTest

@testable import PredictSpring
final class DatabaseManagerTests: XCTestCase {
    
    private var dbManager : DatabaseManager!
    
    override func setUpWithError() throws {
        dbManager = DatabaseManager(dbName: "DB-test")
        dbManager.openDatabase()
        XCTAssertNotNil(dbManager.databasePointer)
        if (!dbManager.checkTableExists()){
            dbManager.createTable()
        }
    }
    
    func testDatabaseTaskValid() {
        let data = ["TEST111,NK XY Core Vent Comp Shor,14.97,14.97,Black,MD",
                    "TEST222,NK XY Core Vent Comp Shor,14.97,14.97,Black,MD",
                    "TEST333,NK XY Core Vent Comp Shor,14.97,14.97,Black,MD",
                    "TEST444,NK XY Core Vent Comp Shor,14.97,14.97,Black,MD"]
        dbManager.openDatabase()
        XCTAssertNotNil(dbManager.databasePointer)
        if (!dbManager.checkTableExists()){
            dbManager.createTable()
        }
        XCTAssertTrue(dbManager.checkTableExists())
        
        // Call method to insert records from test file
        
        dbManager.insertProducts(data: data)
        // Check for inserted records
        var fetchedProducts = dbManager.fetchProducts(withId: "TEST", isNewSearch: true, offset: 0)
        XCTAssertNotNil(fetchedProducts)
        XCTAssertEqual(fetchedProducts!.count, 4)
        XCTAssertEqual(dbManager.getRowCount(), 4)
        
        // Delete the inserted records
        let deleteStatus = dbManager.deleteProducts(withId: "TEST")
        XCTAssertTrue(deleteStatus)
        
        // Check for the same records
        fetchedProducts = dbManager.fetchProducts(withId: "TEST", isNewSearch: true, offset: 0)
        XCTAssertNotNil(fetchedProducts)
        XCTAssertEqual(fetchedProducts!.count, 0)
       
    }

    override func tearDownWithError() throws {
        dbManager = nil
        UserDefaults.standard.setValue(false, forKey: Constants.isProcessingDone)
    }
    
}
