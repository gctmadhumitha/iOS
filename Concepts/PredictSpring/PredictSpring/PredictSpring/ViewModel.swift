//
//  ViewModel.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 04/11/23.
//

import Foundation

struct ViewModel {
    
    var products : [Product]? = []
    var fileUrl : URL?
    let dbManager = DatabaseManager()
    
    func insert()
    {
        print("Begin insertToDb")
        dbManager.saveDataFromCSV(url: fileUrl)
        print("End insertToDb")
    }
    
    func get(){
        print("Begin get")
        let products = dbManager.getData(productId: "")
        print("End get", products)
    }
    
    func download(url: String, progress: ((Float) -> Void)?, completion: ((DownloadStatus)->(Void))?){
        DownloadManager().download(url: url) {  value in
            progress?(value)
        } completion: { status in
            completion?(status)
        }
    }
    
}
