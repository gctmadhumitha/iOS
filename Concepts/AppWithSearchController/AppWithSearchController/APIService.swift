//
//  APIService.swift
//  AppWithSearchController
//
//  Created by Madhumitha Loganathan on 25/10/23.
//

import Foundation


class APIService {
    
    
    static func loadPlaces(queue: DispatchQueue = .main, completion: @escaping ([Place]) -> Void){
        let urlString = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
        let url = URL(string: urlString)!
        var result = [Place]()
        URLSession.shared.dataTask(with: url) { data, response, err in
            if let data = data, err == nil {
                print("data is ", data)
                do {
                    result = try JSONDecoder().decode([Place].self, from:data)
                }catch( let error) {
                    print("error is ", error)
                    result = []
                }
                print("result is ", result)
            }else{
                result = []
            }
            completion(result)
        }.resume()
        
    }
    
    
}
