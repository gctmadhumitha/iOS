//
//  PErson.swift
//  MVVM-Basic-Delegate
//
//  Created by Madhumitha Loganathan on 21/09/23.
//

import Foundation

enum Gender {
    case male, female, unspecified
}

struct Person {
    let firstName: String
    let lastName: String
    let middleName: String?
    let birthDate: Date?
    let address: String?
    let gender: Gender

}
