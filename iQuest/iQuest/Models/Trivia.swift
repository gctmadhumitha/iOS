//
//  Product.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 01/09/23.
//

import UIKit
struct Product {
    var name : String
    var image : String
    var desc : String
}

struct Questions: Decodable {
    private(set) var response_code: Int
    private(set) var results: Array<Question>
    
    init() {
        self.response_code = 0
        self.results = [Question()]
    }
}

class Question: Decodable {
    private(set) var `category`: String
    private(set) var `type`: String
    private(set) var difficulty: String
    private(set) var question: String
    private(set) var correct_answer: String
    private(set) var incorrect_answers: Array<String>
    
    init() {
        self.category = "Geography"
        self.type = "multiple"
        self.difficulty = "medium"
        self.question = "Which country inside the United Kingdom does NOT appear on its flag, the Union Jack?"
        self.correct_answer = "Wales"
        self.incorrect_answers = ["Scotland", "Ireland", "Isle of Wight"]
    }
    
    public func decodeBase64Strings() {
        if let decodedCategory = decodeBase64(string: self.category) {
            self.category = decodedCategory
        }
        
        if let decodedType = decodeBase64(string: self.type) {
            self.type = decodedType
        }
        
        if let decodedDifficulty = decodeBase64(string: self.difficulty) {
            self.difficulty = decodedDifficulty
        }
        
        if let decodedQuestion = decodeBase64(string: self.question) {
            self.question = decodedQuestion
        }
        
        if let decodedCorrectAnswer = decodeBase64(string: self.correct_answer) {
            self.correct_answer = decodedCorrectAnswer
        }
        
        for i in 0..<self.incorrect_answers.count {
            if let decodedIncorrectAnswer = decodeBase64(string: self.incorrect_answers[i]) {
                self.incorrect_answers[i] = decodedIncorrectAnswer
            }
        }
    }
    
    public func printProperties() {
        print("Category: \(self.category)")
        print("Type: \(self.type)")
        print("Difficulty: \(self.difficulty)")
        print("Question: \(self.question)")
        print("Correct Answer: \(self.correct_answer)")
        print("Incorrect answers: \(self.incorrect_answers)")
    }
    
    private func decodeBase64(string: String) -> String? {
        if let stringData = Data(base64Encoded: string) { // First convert string to Base64 Encoded Data
            if let decodedString = String(data: stringData, encoding: .utf8) { // Then, decode string
                return decodedString // If neither return nil, return the new string
            }
        }
        // If the string isn't in Base64 format, return nil and do not update
        return nil
    }
}

struct Category: Decodable {
    private(set) var id = 0
    private(set) var name  = ""
}   

struct Categories: Decodable {
    private(set) var trivia_categories: [Category] = []
}
