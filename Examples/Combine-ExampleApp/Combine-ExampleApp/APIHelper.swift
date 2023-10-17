//
//  APIHelper.swift
//  Combine-ExampleApp
//
//  Created by Madhumitha Loganathan on 20/09/23.
//

import Foundation
import Combine


class APIHelper {
    
    static let shared = APIHelper()
    
    
    func fetchCompanies() -> Future<[String], Error>{
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                promise(.success(["Apple", "Google", "Netflix", "Meta"]))
            }
        }
    }
}
