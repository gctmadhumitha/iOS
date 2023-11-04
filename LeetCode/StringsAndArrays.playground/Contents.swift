import UIKit
import Foundation
var greeting = "Hello, playground"


/// Main Program
func main() {
    print(" #1. countConsistentStrings")
    
    let word = "abc", words = ["a","b","ce","ab","ac","bc","abc", "abcd"]
    print("Input word \(word) , sentence \(words)")
    print("Output :: ", countConsistentStrings(word: word, words: words))
    
    
    print("#2. uniqueEmailAddress")
    
    let emails = ["test.email+alex@leetcode.com","test.e.mail+bob.cathy@leetcode.com","testemail+david@lee.tcode.com"]
    
    print("Input - \(emails)")
    print("Output :: ", uniqueEmailAddress(emails: emails))
    
}


func other(){
    // Creating a dictionary
    var dict = [3: "car", 4: "bike", 19: "bus", 2: "train"]
    
    print("Original Dictionary:", dict)
    
    // Update a key-Value pair
    dict.updateValue("aeroplane", forKey: 7)
    
    // Displaying output
    print("Updated Dictionary:", dict)
}


/// Problem#1 - countConsistentStrings
func countConsistentStrings(word: String, words: [String]) -> Int {
    
    var count = words.count
    guard word.count > 0 && words.count > 0 else{
        return 0
    }
    var letterMap = [Character : Int]()
    /// Create a Hash Map of the letters of the allowed word
    for letter in word {
        letterMap.updateValue(1, forKey: letter)
    }
    
    /// Iterate through each word to check if it has only the letters from the allowed word
    for word in words {
        for letter in word {
            if letterMap[letter] == nil {
                count -= 1
                break
            }
        }
    }
    return count
    
}


/*
 Problem #2 :
 
 https://leetcode.com/problems/unique-email-addresses/
 
 Input: emails = ["test.email+alex@leetcode.com","test.e.mail+bob.cathy@leetcode.com","testemail+david@lee.tcode.com"]
 Output: 2
 Explanation: "testemail@leetcode.com" and "testemail@lee.tcode.com" actually receive mails.
 
 ##Assumption - The emails are valid
 
 */
func uniqueEmailAddress(emails : [String]) -> [String]{
    var uniqueEmails = [String: Int]()
    
    for var email in emails {
        var emailFirst = email.split(separator: "@").first
        let emailLast = email.split(separator: "@").last
        // check - 1 test.email+alex
        let plusIndex = email.firstIndex(of: "+")
        if let plusIndex = plusIndex, var emailFirst = emailFirst, let emailLast = emailLast {
            emailFirst = email[..<plusIndex]
            // check - 2 test.e.mail+bob
            emailFirst.removeAll(where: { $0 == "."
            })
            email = "\(emailFirst)@\(emailLast)"
            
            if var uEmail = uniqueEmails[email] {
                uEmail += uEmail + 1
            } else {
                uniqueEmails[email] = 1
            }
        }
    }
    return Array(uniqueEmails.keys)
}




main()
