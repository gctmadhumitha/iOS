//
//  ViewModel.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 04/11/23.
//

import Foundation

class ProductsViewModel {
    
    private(set) var products : [Product] = []
    private var fileUrl : URL?
    private let dbManager = DatabaseManager()
    private let productsPerBatch = 20
    private var offset = 0
    private var reachedEndOfProducts = false
    private var isFetchInProgress = false
    
    var totalCount : Int {
        print("products count : \(products.count)")
        print("offset : \(offset)")
        return products.count
    }
    
    
    func product(at index: Int) -> Product {
      return products[index]
    }
    
    func insert()
    {
        print("Begin insertToDb")
        dbManager.saveDataFromCSV(url: fileUrl)
        print("End insertToDb")
    }
    
    func fetchProducts(){
        print("Begin get")
        let products = dbManager.getData(productId: "", offset: offset)
        if let products = products {
            self.products += products
            self.offset += products.count
        }
    }
    
    func download(url: String, progress: ((Float) -> Void)?, completion: ((DownloadStatus)->(Void))?){
        DownloadManager().download(url: url) {  value in
            progress?(value)
        } completion: { status in
            completion?(status)
        }
    }
    
    private func calculateIndexPathsToReload(from newProducts: [Product]) -> [IndexPath] {
      let startIndex = newProducts.count - newProducts.count
      let endIndex = startIndex + newProducts.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
