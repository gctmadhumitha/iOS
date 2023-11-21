//
//  ViewModel.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 05/11/23.
//

import Foundation
import Alamofire

class ProductsViewModel {
    
    private(set) var products : [Product] = []
    private var total  = 0
    private var fileUrl : URL?
    private let dbManager = DatabaseManager()
    private let productsPerBatch = 20
    private var offset = 0
    
    //For Read
    var hasReachedEndOfProducts = false
    
    //For BatchInsert
    var progress = 0
    
    var totalCount : Int {
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
    
    
    func insertStream(products: [String], progressHandler: ((Int) -> Void)? = nil, completionHandler: ((DatabaseStatus)->(Void))?)
    {
        self.dbManager.importDataFromStream(products: products) { value in
            print("value is" , value)
            progressHandler?(value)
        } completionHandler: { status in
            completionHandler?(status)
        }
       
    }
    
    func getRowCount() -> Int {
        return self.dbManager.getRowCount()
    }
    
    
    private func calculateIndexPathsToReload(from newProducts: [Product]) -> [IndexPath] {
      let startIndex = newProducts.count - newProducts.count
      let endIndex = startIndex + newProducts.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    
    func downloadStreamAndInsert(url: String, progressHandler: ((Float) -> Void)?, completionHandler: ((DatabaseStatus)->(Void))?){
        
        guard let url = URL(string: url) else {
            return
        }
        var productsInAStream = [String]()
        var isHeaderLine = true
        var partialString = ""
        let group = DispatchGroup()
        AF.streamRequest(url).responseStreamString { stream in
            switch stream.event {
            case let .stream(result):
                productsInAStream = []
                switch result {
                case let .success(string):
                    let lines = string.split(separator: "\n")
                    for (index,line) in lines.enumerated() {
                        var productString = line
                        if index == 0  {
                            if isHeaderLine {
                                // Ignore first line with the column names
                                isHeaderLine = false
                                continue
                            }
                            if partialString.count != 0  {
                                let fields = productString.split(separator:",")
                                //if new line doesn't starts with product id,combine partial line and new line and that forms the productString
                                if !productString.starts(with: "99") || (fields.count > 0 && fields[0].count != 14) {
                                    productString = partialString + productString
                                    partialString = ""
                                    
                                    let combinedFields = productString.split(separator:",")
                                    if combinedFields.count < 6 {
                                        print("Combined String", productString)
                                        // If a single product comes split more than two lines
                                        fatalError()
                                    }
                                }
                                // If new line  starts with product id,
                                // 1. new line is a productString
                                // 2. check if partial line is already a full product string, add this to array
                                else {
                                    let partialStringfields = productString.split(separator:",")
                                    if partialString.starts(with: "99") && partialStringfields.count == 6 && partialStringfields[0].count == 14 {
                                        productsInAStream.append(String(partialString))
                                        partialString = ""
                                    }
                                    else {
                                        // This should not be printed
                                        print("ERROR:: partialString \(partialString) productString: \(productString)")
                                        fatalError()
                                    }
                                }
                                
                            }
                        } else if (index == lines.count - 1) {
                                partialString = String(line)
                                continue
                        }
                        self.total +=  1
                        // case : When the buffer has just one line this case happens
                        let fields = productString.split(separator: ",")
                        if fields.count == 6 {
                            productsInAStream.append(String(productString))
                        }else{
                            partialString = String(productString)
                        }
                    }
                }
                
                group.enter()
                self.insertStream(products: productsInAStream, completionHandler: { status in
                    switch status {
                    case .completed:
                        self.total += productsInAStream.count
                        progressHandler?(Float(self.total))
                        group.leave()
                        progressHandler?(Float(self.total))
                    default:
                        print("status is" , status)
                    }
                })
            case .complete:
                print("Total products " , self.total)
                if partialString.count != 0 {
                    self.dbManager.insertProduct(data: partialString)
                }
                group.notify(queue: DispatchQueue.main) {
                    completionHandler?(.completed(self.total))
                }
            }
        }
    }
        
    func createProduct(fields: [Substring.SubSequence]) -> Product {
        let productId = String(describing: fields[0])
        let title = String(describing:fields[1])
        let listPrice = String(describing:fields[2])
        let salesPrice = String(describing:fields[3])
        let color = String(describing:fields[4])
        let size = String(describing:fields[5])
        return Product(productId: productId, title: title, listPrice: Double(listPrice) ?? 0,  salesPrice: Double(salesPrice) ?? 0, color: color, size: size)
    }
    
    func deleteAllProducts() -> Bool {
        let delete =  dbManager.deleteAll(table: "PRODUCTS")
        products = []
        return delete
    }
    
    func isPartialLine(line: String, numberOfFields: Int) -> Bool {
        let fields = line.split(separator:",")
        if fields.count != numberOfFields {
            return true
        }
        if fields[0].count != 14 || !fields[0].starts(with: "99"){
            return true
        }
        return false
    }
    
    
}
