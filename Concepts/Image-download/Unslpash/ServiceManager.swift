//
//  Service.swift
//  Unslpash
//
//  Created by Madhumitha Loganathan on 26/10/23.
//  Copyright © 2023 Sam Meech-Ward. All rights reserved.
//

import Foundation


class ServiceManager {
    static let shared = ServiceManager()
    
    private init(){}
    
    func fetchPhotos(category: String, completion : @escaping (([Post]?) -> Void)) {
        
        let url = URL(string: "")
        guard let url = url else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { ( data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let json = try? JSONDecoder().decode(Post.self, from: data)
            
        }
    }
}
