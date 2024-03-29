//
//  ViewModel.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 05/11/23.
//

import Foundation

class ProductsViewModel {
    
    private(set) var products : [Product] = []
    private var fileUrl : URL?
    private let dbManager = DatabaseManager()
    private let productsPerBatch = 20
    private var offset = 0
    
    //For Read
    var hasReachedEndOfProducts = false
    
    //For BatchInsert
    var progress = 0
    
    var totalCount : Int {
        //print("products count : \(products.count)")
        //print("offset : \(offset)")
        return products.count
    }
    
    
    func product(at index: Int) -> Product {
      return products[index]
    }

    func fetchProducts(id: String, isNewSearch: Bool = true){
        if isNewSearch {
            offset = 0
        }
        let products = dbManager.fetchProducts(withId: id, isNewSearch: isNewSearch, offset: offset)
        
        if let products = products {
            if(isNewSearch) {
                self.products = products
                self.offset  = products.count
            } else{
                self.products += products
                self.offset += products.count
            }
            self.hasReachedEndOfProducts = false
        } else {
            self.hasReachedEndOfProducts = true
        }
    }
    
    func insert(url: URL, progressHandler: ((Int) -> Void)?, completionHandler: ((DatabaseStatus)->(Void))?)
    {
        self.dbManager.importDataFromFile(url: url) { value in
            progressHandler?(value)
        } completionHandler: { status in
            completionHandler?(status)
        }
    }
    
    
    func deleteAllProducts() -> Bool {
        let delete =  dbManager.deleteAll(table: "PRODUCTS")
        products = []
        return delete
    }
    
    
    func getRowCount() -> Int {
        return self.dbManager.getRowCount()
    }
    
    func download(url: String, progressHandler: ((Float) -> Void)?, completionHandler: ((DownloadStatus)->(Void))?){
        DownloadManager().download(url: url) {  value in
            progressHandler?(value)
        } completionHandler: { status in
            completionHandler?(status)
        }
    }
    
    private func calculateIndexPathsToReload(from newProducts: [Product]) -> [IndexPath] {
      let startIndex = newProducts.count - newProducts.count
      let endIndex = startIndex + newProducts.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
