//
//  Product.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 01/09/23.
//

import Foundation

import UIKit
struct Product {
    var name : String
    var image : String
    var desc : String
}

struct Question: Decodable {
    private(set) var `category`: String?
    private(set) var question: String?
    private(set) var correct_answer: String?
    private(set) var incorrect_answers: Array<String>?
}

struct Questions: Decodable {
    private(set) var response_code: Int
    private(set) var results: Array<Question>
    
    init() {
        self.response_code = 0
        self.results = [Question()]
    }
}

struct Category: Decodable {
    private(set) var id = 0
    private(set) var name  = ""
}   

struct Categories: Decodable {
    private(set) var trivia_categories: [Category] = []
}
