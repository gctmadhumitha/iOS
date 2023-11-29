//
//  DatabaseManager.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 05/11/23.
//

import Foundation
import SQLite3

class DatabaseManager {
    
    private var dbName = Constants.databaseName
    private let filePath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    private var linesRead : CGFloat = 0
    private var total: CGFloat = 1
    private var databaseSaveComplete = false {
        didSet {
            UserDefaults.standard.set(databaseSaveComplete, forKey: Constants.isDatabaseSaveComplete)
        }
    }
    private var allRecordsFetched = false
    var databasePointer: OpaquePointer?
    
    init(dbName: String = Constants.databaseName){
        self.dbName = dbName
    }
    
    // Method to Open SQLite Database
    func openDatabase() {
        guard let databasePath = filePath?.appendingPathComponent(dbName) else {
            print("Database does not exist")
            return
        }
        if sqlite3_open_v2(databasePath.path, &databasePointer, SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX|SQLITE_OPEN_CREATE, nil) == SQLITE_OK {
            print("Database connection successful")
        } else {
            print("Not able to open database")
            return
        }
    }
    
    // Check DB if it exists
    func checkDBExists() -> Bool {
        guard (filePath?.appendingPathComponent(dbName)) != nil else {
            print("DB path not available")
            return false
        }
        return true
    }
    
    // Lookup for Table
    func checkTableExists() -> Bool {
        
        var tablePointer: OpaquePointer?
        let tableExistString = "SELECT name FROM sqlite_master WHERE type='table' AND name='PRODUCTS';"
        if sqlite3_prepare_v2(databasePointer, tableExistString, -1, &tablePointer, nil) == SQLITE_OK {
            if sqlite3_step(tablePointer) == SQLITE_ROW {
                sqlite3_finalize(tablePointer)
                return true
            }
        }
        sqlite3_finalize(tablePointer)
        return false
    }
    
    // Creating Products Table
    func createTable() {
        var createTablePointer: OpaquePointer?
        
        let createTableQuery: String = """
        CREATE TABLE PRODUCTS(productId TEXT PRIMARY KEY NOT NULL,
        title VARCHAR(255),
        listPrice,
        salesPrice,
        color VARCHAR(255),
        size VARCHAR(255));
        """
        
        if sqlite3_prepare_v2(databasePointer, createTableQuery, -1, &createTablePointer, nil) == SQLITE_OK {
            if sqlite3_step(createTablePointer) == SQLITE_DONE {
                print("\n PRODUCTS table created")
            } else {
                print("PRODUCTS table could not be created")
            }
        } else {
            print("CREATE TABLE query error")
        }
        sqlite3_finalize(createTablePointer)
    }

    // Insert data to Table
    func insertProducts(data: [String]) {
        
        var insertPointer: OpaquePointer?
        let insertQuery = "INSERT INTO PRODUCTS VALUES(?,?,?,?,?,?);"
        
        let returned = sqlite3_exec(databasePointer, "BEGIN TRANSACTION", nil, nil, nil);
        if sqlite3_prepare_v2(databasePointer, insertQuery, -1, &insertPointer, nil) ==
            SQLITE_OK {
            for content in data {
                let columns = content.split(separator: ",")
                let id = columns[0] as NSString
                let title = columns[1] as NSString
                let color = columns[4] as NSString
                let size = columns[5] as NSString
                if let listPrice = Double(columns[2]), let salesPrice = Double(columns[3]) {
                    sqlite3_bind_text(insertPointer, 1, id.utf8String, -1, nil)
                    sqlite3_bind_text(insertPointer, 2, title.utf8String, -1, nil)
                    sqlite3_bind_double(insertPointer, 3, listPrice)
                    sqlite3_bind_double(insertPointer, 4, salesPrice)
                    sqlite3_bind_text(insertPointer, 5, color.utf8String, -1, nil)
                    sqlite3_bind_text(insertPointer, 6, size.utf8String,-1, nil)
                    if !(sqlite3_step(insertPointer) == SQLITE_DONE) {
                        print("Could not insert row")
                    }
                }
                sqlite3_reset(insertPointer)
            }
        } else {
            print(sqlite3_prepare_v2(databasePointer, insertQuery, -1, &insertPointer, nil))
        }
        sqlite3_exec(databasePointer, "COMMIT ", nil, nil, nil);
        sqlite3_finalize(insertPointer)
    }
    
    // Queries PRODUCTS table for records containing 'id' string and returns the matching products
    func fetchProducts(withId id: String, isNewSearch: Bool = true, offset: Int = 0, rowsPerBatch: Int = 20) -> [Product]? {
        
        if databasePointer == nil {
            openDatabase()
        }
        
        if allRecordsFetched && !isNewSearch {
            return nil
        }
        
        var fetchPointer: OpaquePointer?
        let fetchProductsQuery = "SELECT * FROM PRODUCTS WHERE productId LIKE '%\(id)%' LIMIT 20 OFFSET \(offset);"
        var products: [Product] = []
        if sqlite3_prepare_v2(databasePointer, fetchProductsQuery, -1, &fetchPointer, nil) ==
            SQLITE_OK {
            while(sqlite3_step(fetchPointer) == SQLITE_ROW) {
                let id = String(describing: String(cString: sqlite3_column_text(fetchPointer, 0)))
                let title = String(describing: String(cString: sqlite3_column_text(fetchPointer, 1)))
                let listPrice = sqlite3_column_double(fetchPointer, 2)
                let salesPrice = sqlite3_column_double(fetchPointer, 3)
                let color = String(describing: String(cString: sqlite3_column_text(fetchPointer, 4)))
                let size = String(describing: String(cString: sqlite3_column_text(fetchPointer, 5)))
                
                products.append(Product(productId: id, title: title, listPrice: listPrice, salesPrice: salesPrice, color: color, size: size))
            }
            DispatchQueue.main.async{
                if products.count < rowsPerBatch {
                    self.allRecordsFetched = true
                }
            }
        } else {
            print(sqlite3_prepare_v2(databasePointer, fetchProductsQuery, -1, &fetchPointer, nil))
        }
        sqlite3_finalize(fetchPointer)
        return products
    }
    
    // Deletes matching records from DB
    func deleteProducts(withId id: String) -> Bool {
        if id.count < 1 {
            return false
        }
        if databasePointer == nil {
            openDatabase()
        }
        var deletePointer: OpaquePointer?
        let deleteDataQuery = "DELETE FROM PRODUCTS WHERE productId LIKE '%\(id)%';"
        var isDeleteSuccessful = false
        
        if sqlite3_prepare_v2(databasePointer, deleteDataQuery, -1, &deletePointer, nil) ==
            SQLITE_OK {
            if sqlite3_step(deletePointer) == SQLITE_DONE {
                isDeleteSuccessful = true
                print("Successfully deleted rows.")
            } else {
                print("Could not delete rows.")
            }
        } else {
            print(sqlite3_prepare_v2(databasePointer, deleteDataQuery, -1, &deletePointer, nil))
        }
        sqlite3_finalize(deletePointer)
        return isDeleteSuccessful
    }
    
    // Delete all rows from table
    func deleteAll(table: String) -> Bool{
        if table.count < 1 {
            return false
        }
        if databasePointer == nil {
            openDatabase()
        }
        var deletePointer: OpaquePointer?
        let deleteDataQuery = "DELETE FROM \(table);"
        var isDeleteSuccessful = false
        
        if sqlite3_prepare_v2(databasePointer, deleteDataQuery, -1, &deletePointer, nil) ==
            SQLITE_OK {
            if sqlite3_step(deletePointer) == SQLITE_DONE {
                isDeleteSuccessful = true
                
                print("Successfully deleted rows.")
            } else {
                print("Could not delete rows.")
            }
        } else {
            print(sqlite3_prepare_v2(databasePointer, deleteDataQuery, -1, &deletePointer, nil))
        }
        sqlite3_finalize(deletePointer)
        return isDeleteSuccessful
    }
    
    
    // Records count of Products Table
    func getRowCount() -> Int {
        var count = 0
        var countPointer: OpaquePointer?
        let countQuery = "SELECT count(*) from PRODUCTS;"
        if sqlite3_prepare(databasePointer, countQuery, -1, &countPointer, nil) == SQLITE_OK{
              while(sqlite3_step(countPointer) == SQLITE_ROW){
                   count = Int(sqlite3_column_int(countPointer, 0))
              }
        }
        return count
    }
    
    func importDataFromFile(url: URL?, progressHandler: ((Int) -> Void)?, completionHandler: ((DatabaseStatus)->(Void))?) {
        if databasePointer == nil {
            openDatabase()
        }
        if !checkTableExists() {
            createTable()
        }
        guard let url = url else {
            print("File not found at location")
            return
        }
        let path = url.path
        let fileSize = getSizeOfFile(path: path)
        let rowCount = getRowCount()
        
        DispatchQueue.main.async {
            if fileSize == rowCount {
                self.databaseSaveComplete = true
            }
            self.total = CGFloat(fileSize)
            self.linesRead = CGFloat(0)
        }
        
        guard let file = freopen(path, "r", stdin) else {
            print("Cannot read file")
            return
        }
        defer {
            fclose(file)
        }
        
        // Skip first line
        _ = readLine()
        
        var lines: [String] = []
        var lineCounter = 0
        let linesPerBlock = 1000
        while let line = readLine() {
            lines.append(line)
            lineCounter += 1
            if ((lineCounter % linesPerBlock) == 0) {
                DispatchQueue.main.async {
                    self.linesRead += CGFloat(linesPerBlock)
                    progressHandler?(Int(self.linesRead))
                }
                    insertProducts(data: lines)
                    lines = []
                
            }
            
        }
        insertProducts(data: lines)
        DispatchQueue.main.async {
            self.databaseSaveComplete = true
            completionHandler?(.completed(Int(self.linesRead)))
        }
    }
    
    func getSizeOfFile(path: String) -> Int {
        let key = "FileSize"
        let size = UserDefaults.standard.integer(forKey: key)
        if size != 0 {
            return size
        }
        guard let file = freopen(path, "r", stdin) else {
            print("Cannot read file")
            exit(0)
        }
        defer {
            fclose(file)
        }
        var lines = 0
        _ = readLine()
        while readLine() != nil {
            lines += 1
        }
        if lines == 0 {
            print("No items in file")
            exit(0)
        }
        UserDefaults.standard.set(lines, forKey: key)
        return lines
    }
    
}

enum DatabaseStatus{
    case completed(Int)
    case error
}
