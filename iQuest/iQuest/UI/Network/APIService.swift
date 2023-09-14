//
//  APIHelper.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 05/09/23.
//
// The App uses Trivia API provided by Open Trivia Datbase
// The Open Trivia Database provides a completely free JSON API for use in programming projects.
// Example API : https://opentdb.com/api.php?amount=10



import Foundation

class APIService {
    
    public func fetchQuizsFor(category: Int) async -> (questions: Array<Question>, error: String?) {
        
        let urlString: String = "https://opentdb.com/api.php?amount=10&category=\(category)&difficulty=easy&type=multiple&encode=base64"
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return ([], "Server response error.")
            }
            
            if response.statusCode != 200 {
                return ([], "Error: \(response.statusCode)")
            }
            
            guard let questions = try? JSONDecoder().decode(Questions.self, from: data) else {
                return ([], "An error occured while decoding trivia data. ")
            }
            if questions.response_code == 0 {
                return (questions.results, nil)
            } else if questions.response_code != 0 {
                return ([], "An error occured while fetching trivia from Open Trivia Database. Please try again")
            }
            
        } catch let error {
            print(error.localizedDescription)
            return ([], error.localizedDescription)
        }
        return([], "error")
    }
    
    
    
    public func fetchQuizFor(category: Int, amount: Int) async -> (questions: Array<Question>, error: String?) {
        // Sample https://opentdb.com/api.php?amount=10&category=10&difficulty=medium&type=multiple
        let urlString: String = "https://opentdb.com/api.php?amount=\(amount)&category=\(category)&difficulty=easy&type=multiple&encode=base64"
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (dataResponse, urlResponse) = try await URLSession.shared.data(for: request)
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                return ([], "Server response error.")
            }
            
            if httpUrlResponse.statusCode != 200 {
                return ([], "Error: \(httpUrlResponse.statusCode)")
            }
            
            guard let decodedData = try? JSONDecoder().decode(Questions.self, from: dataResponse) else {
                return ([], "An error occured obtaining trivia questions. Try again")
            }
            
            if decodedData.response_code == 1 {
                return ([], "Not enough questions in database 😕")
            } else if decodedData.response_code != 0 {
                return ([], "There was an error initializing game 😕")
            }
            
            print("Successfully fetched trivia questions!")
            
            for var question in decodedData.results {
                question.decodeBase64Strings()
                print("question.decodeBase64Strings() : \(question)")
            }
            return (decodedData.results, nil) // Successful
            
        } catch let error {
            print(error.localizedDescription)
            return ([], error.localizedDescription)
        }
    }
    
    
    
    
    public func fetchQuizCategories() async -> (categories: Categories?, error: String)
    {
        
        let apiUrl = "https://opentdb.com/api_category.php"
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            print("data is \(data)")
            print("response is \(response)")
            guard let _ = response as? HTTPURLResponse else {
                return (nil, "Error: response received nil")
            }
            
            guard let categories = try? JSONDecoder().decode(Categories.self, from: data) else{
                return (nil, "Error decoding categories")
            }
            print("Categories decoded is \(categories)")
            return (categories, "Success")
            
        }catch let error {
            print("Error caught while fetching trivia categories", error.localizedDescription)
            return(nil, "Error occured")
        }
    }
    
//    public func fetchTriviaCategories() async -> (categories: Array<TriviaCategory>, error: String?) {
//        let apiURL = URL(string: "https://opentdb.com/api_category.php")!
//        var request = URLRequest(url: apiURL)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        do {
//            let (dataResponse, urlResponse) = try await URLSession.shared.data(for: request) // URLResponse is not needed since a status code is provided by the API
//            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
//                return ([], "Server response error.")
//            }
//
//            if httpUrlResponse.statusCode != 200 {
//                return ([], "Error: \(httpUrlResponse.statusCode)")
//            }
//
//            guard let decodedData = try? JSONDecoder().decode(TriviaCategories.self, from: dataResponse) else {
//                // Handle nil case
//                print("Decode error")
//                return ([], "An error occured obtaining categories. Try again")
//            }
//
//            print("Successfully fetched category data!")
//
//            return (decodedData.trivia_categories, nil)
//
//        } catch let error {
//            print(error.localizedDescription)
//            return ([], error.localizedDescription)
//        }
//    }
    
    
    public func fetchFact() async -> (fact: Fact?, error: String)
    {
        
        let apiUrl = "https://uselessfacts.jsph.pl/api/v2/facts/random"
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            print("data is \(data)")
            print("response is \(response)")
            guard let _ = response as? HTTPURLResponse else {
                return (nil, "Error: response received nil")
            }
            
            guard let fact = try? JSONDecoder().decode(Fact.self, from: data) else{
                return (nil, "Error decoding categories")
            }
            
            print("Fact is \(fact)")
            return(fact, "Success")
            
        }  catch let error {
            print(error.localizedDescription)
            return(nil, "Error fetching fact")
        }
    }
}
