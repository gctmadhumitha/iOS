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
        XCTAssertNotNil(dbManager.db)
        if (!dbManager.checkTableExists()){
            dbManager.createTable()
        }
    }
    
    func test_UnitTestDatabaseTask_invalid() {
        dbManager.openDatabase()
        XCTAssertNotNil(dbManager.db)
        if (!dbManager.checkTableExists()){
            dbManager.createTable()
        }
        XCTAssertTrue(dbManager.checkTableExists())
        
        // Call method to insert records from test file
        if let filePath = Bundle(for: DownloadManagerTests.self).path(forResource: "test", ofType: "csv") {
            let fileUrl = URL(fileURLWithPath: filePath)
            dbManager.saveDataFromCSV(url: fileUrl, progressHandler: nil,completionHandler: nil)
        }else{
            XCTFail("Test file not found")
        }
        
        // Check for inserted records
        var insertedProducts = dbManager.fetchProducts(withId: "TEST", isNewSearch: true, offset: 0)
        XCTAssertNotNil(insertedProducts)
        XCTAssertEqual(insertedProducts!.count, 4)
        
        var rowCount = dbManager.getRowCount()
        XCTAssertEqual(rowCount, 4)
        
        // Delete the inserted records
        let deletedProducts = dbManager.deleteProducts(withId: "TEST")
        
        // Check for the same records
        insertedProducts = dbManager.fetchProducts(withId: "TEST", isNewSearch: true, offset: 0)
        XCTAssertNotNil(insertedProducts)
        XCTAssertEqual(insertedProducts!.count, 0)
       
    }

    override func tearDownWithError() throws {
        dbManager = nil
    }
    
}
