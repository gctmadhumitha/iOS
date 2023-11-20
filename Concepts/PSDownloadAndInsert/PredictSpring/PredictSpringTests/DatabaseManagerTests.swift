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
        dbManager.openDatabase()
        XCTAssertNotNil(dbManager.databasePointer)
        if (!dbManager.checkTableExists()){
            dbManager.createTable()
        }
        XCTAssertTrue(dbManager.checkTableExists())
        
        // Call method to insert records from test file
        if let filePath = Bundle(for: DownloadManagerTests.self).path(forResource: "test", ofType: "csv") {
            let fileUrl = URL(fileURLWithPath: filePath)
            dbManager.importDataFromFile(url: fileUrl, progressHandler: nil,completionHandler: nil)
        }else{
            XCTFail("Test file not found")
        }
        
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
        UserDefaults.standard.setValue(false, forKey: Constants.isDatabaseSaveComplete)
    }
    
}
