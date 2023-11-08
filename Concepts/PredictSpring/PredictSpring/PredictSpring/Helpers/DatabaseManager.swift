//
//  DatabaseManager.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 03/11/23.
//

import Foundation
import SQLite3

class DatabaseManager {
    
    var dbName = Constants.db_name
    init(dbName: String = Constants.db_name){
        self.dbName = dbName
    }
    let filePath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    
    var db: OpaquePointer?
    var result: [Product] = []
    var progress: CGFloat = 0
    var total: CGFloat = 1
    var databaseSaveComplete = false {
        didSet {
            UserDefaults.standard.set(databaseSaveComplete, forKey: Constants.isDatabaseSaveComplete)
        }
    }
    var noMoreDataInDB = false
    
    func checkDBExists() -> Bool {
        guard (filePath?.appendingPathComponent(dbName)) != nil else {
            print("DB path not available")
            return false
        }
        return true
    }
    
    func saveToDatabaseBatchProcessing(data: [String]) {
        let rowInsertString = "INSERT INTO PRODUCTS VALUES(?,?,?,?,?,?);"
        var insertPointer: OpaquePointer?
        sqlite3_exec(db, "BEGIN TRANSACTION", nil, nil, nil);
        if sqlite3_prepare_v2(db, rowInsertString, -1, &insertPointer, nil) ==
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
            print(sqlite3_prepare_v2(db, rowInsertString, -1, &insertPointer, nil))
        }
        sqlite3_exec(db, "COMMIT TRANSACTION", nil, nil, nil);
        sqlite3_finalize(insertPointer)
    }
    
    func getRowCount() -> Int {
        let getCountString = "SELECT count(*) from PRODUCTS;"
        var getCountPointer: OpaquePointer?
        var count = 0
        if sqlite3_prepare(db, getCountString, -1, &getCountPointer, nil) == SQLITE_OK{
              while(sqlite3_step(getCountPointer) == SQLITE_ROW){
                   count = Int(sqlite3_column_int(getCountPointer, 0))
              }
        }
        return count
    }
    
    func checkTableExists() -> Bool {
        let tableExistString = "SELECT name FROM sqlite_master WHERE type='table' AND name='PRODUCTS';"
        var tablePointer: OpaquePointer?
        if sqlite3_prepare_v2(db, tableExistString, -1, &tablePointer, nil) == SQLITE_OK {
            if sqlite3_step(tablePointer) == SQLITE_ROW {
                sqlite3_finalize(tablePointer)
                return true
            }
        }
        sqlite3_finalize(tablePointer)
        return false
    }
    
    func createTable() {
        var createTableStatement: OpaquePointer?
        
        let createTableString: String = """
        CREATE TABLE PRODUCTS(productId TEXT PRIMARY KEY NOT NULL,
        title VARCHAR(255),
        listPrice,
        salesPrice,
        color VARCHAR(255),
        size VARCHAR(255));
        """
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\n PRODUCTS table created")
            } else {
                print("PRODUCTS table cannot be created")
            }
        } else {
            print("CREATE TABLE statement not prepared")
        }
        sqlite3_finalize(createTableStatement)
    }

    func openDatabase() {
        guard let dBPath = filePath?.appendingPathComponent(dbName) else {
            print("DB path not available")
            return
        }
        print("DB path :\(dBPath)")
        if sqlite3_open(dBPath.path, &db) == SQLITE_OK {
            print("Successfully connected to the DB")
        } else {
            print("Unable to open database")
            return
        }
    }

    func fetchProducts(withId id: String, isNewSearch: Bool = true, offset: Int = 0, rowsPerBatch: Int = 20) -> [Product]? {
        if db == nil {
            openDatabase()
        }
        let getDataString = "SELECT * FROM PRODUCTS WHERE productId LIKE '%\(id)%' LIMIT 20 OFFSET \(offset);"
        
        if noMoreDataInDB && !isNewSearch {
            return nil
        }

        var getPointer: OpaquePointer?
        var tempResult: [Product] = []
        if sqlite3_prepare_v2(db, getDataString, -1, &getPointer, nil) ==
            SQLITE_OK {
            /// productId
            //sqlite3_bind_text(getPointer, 1, id.utf8String, -1, nil)
            ///Limit
            //sqlite3_bind_int(getPointer, 2, Int32(rowsPerBatch))
            ///Offset
            //sqlite3_bind_int(getPointer, 3, Int32(offset))
            while(sqlite3_step(getPointer) == SQLITE_ROW) {
                let id = String(describing: String(cString: sqlite3_column_text(getPointer, 0)))
                let title = String(describing: String(cString: sqlite3_column_text(getPointer, 1)))
                let listPrice = sqlite3_column_double(getPointer, 2)
                let salesPrice = sqlite3_column_double(getPointer, 3)
                let color = String(describing: String(cString: sqlite3_column_text(getPointer, 4)))
                let size = String(describing: String(cString: sqlite3_column_text(getPointer, 5)))
                
                tempResult.append(Product(productId: id, title: title, listPrice: listPrice, salesPrice: salesPrice, color: color, size: size))
                
            }
            if tempResult.count < rowsPerBatch {
                DispatchQueue.main.async {
                    self.noMoreDataInDB = true
                }
            }
            DispatchQueue.main.async {
                self.result += tempResult
                //self.dataFetched = true
            }

        } else {
            print(sqlite3_prepare_v2(db, getDataString, -1, &getPointer, nil))
        }
        sqlite3_finalize(getPointer)
        return tempResult
    }
    
    
    func deleteProducts(withId id: String) -> Bool {
        
        if id.count < 1 {
            return false
        }
        if db == nil {
            openDatabase()
        }
        let deleteDataString = "DELETE FROM PRODUCTS WHERE productId LIKE ?;"
        var deletePointer: OpaquePointer?
        let id =  "'%\(id)%'" as NSString
        var isDeleteSuccessful = false
        if sqlite3_prepare_v2(db, deleteDataString, -1, &deletePointer, nil) ==
            SQLITE_OK {
            /// productId
            sqlite3_bind_text(deletePointer, 1, id.utf8String, -1, nil)
            if sqlite3_step(deletePointer) == SQLITE_DONE {
                isDeleteSuccessful = true
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print(sqlite3_prepare_v2(db, deleteDataString, -1, &deletePointer, nil))
        }
        sqlite3_finalize(deletePointer)
        return isDeleteSuccessful
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
    
    func performDBSetupChecks() {
        if db == nil {
            openDatabase()
        }
        
        if !checkTableExists() {
            createTable()
        }
    }
    
    func saveDataFromCSV(url: URL?, progressHandler: ((Int) -> Void)?, completionHandler: ((DatabaseStatus)->(Void))?) {
        performDBSetupChecks()
        guard let url = url else {
            print("File not found at location")
            return
        }

        let path = url.path
        let fileSize = getSizeOfFile(path: path)
        if  fileSize == getRowCount() {
            DispatchQueue.main.async {
                self.databaseSaveComplete = true
            }
            return
        }
        DispatchQueue.main.async {
            self.total = CGFloat(fileSize)
            self.progress = CGFloat(0)
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
        let chunkSize = 5000
        while let line = readLine() {
            lines.append(line)
            lineCounter += 1
            if ((lineCounter % chunkSize) == 0) {
                DispatchQueue.main.async {
                    self.progress += CGFloat(chunkSize)
                    let progressValue = Float(self.progress)
                    progressHandler?(Int(progressValue))
                }
                autoreleasepool{
                    saveToDatabaseBatchProcessing(data: lines)
                    lines = []
                }
            }
            
        }
        saveToDatabaseBatchProcessing(data: lines)
        DispatchQueue.main.async {
            self.databaseSaveComplete = true
            let progressValue = Int(self.progress)
            completionHandler?(.completed(progressValue))
        }
    }
    
}

enum DatabaseStatus{
    case completed(Int)
    case error
}
