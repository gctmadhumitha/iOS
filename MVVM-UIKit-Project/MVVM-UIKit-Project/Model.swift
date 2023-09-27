//
//  Model.swift
//  MVVM-UIKit-Project
//
//  Created by Madhumitha Loganathan on 26/09/23.
//

import Foundation

struct UsersResponse : Codable {
    let data : [PersonResponse]
}

struct PersonResponse : Codable {
    let email : String
    let firstName: String
    let lastName : String
}
