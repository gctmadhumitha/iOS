//
//  QuizBrain.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 13/09/23.
//

import Foundation

struct QuizBrain {
    
    var questionNumber = 0
    var correctQuestions = 0
    var wrongQuestions = 0
    
    
    let quiz = [
        Question(category: "Category", question: "What is the capital of Iceland?", correct_answer: "Reyjavik", incorrect_answers: ["Paris", "Reyjavik", "Oslo", "London"]),
        Question(category: "Category", question: "What is the capital of Bhutan?", correct_answer: "Thimpu", incorrect_answers: ["Paris", "Thimpu", "Oslo", "London"]),
        Question(category: "Category", question: "What is the capital of England?", correct_answer: "Thimpu", incorrect_answers: ["Paris", "Thimpu", "Oslo", "London"]),
        Question(category: "Category", question: "What is the capital of France?", correct_answer: "Thimpu", incorrect_answers: ["Paris", "Thimpu", "Oslo", "London"]),
        Question(category: "Category", question: "What is the capital of Norway?", correct_answer: "Thimpu", incorrect_answers: ["Paris", "Copenhagen", "Oslo", "London"])
    ]
    
    func getQuestionsText() -> String {
        return quiz[questionNumber].question!
    }
    
    func getProgress() -> Float {
        return Float(questionNumber)/Float(quiz.count)
    }
    
    func getScore() -> Int {
        return correctQuestions
    }
    
    mutating func nextQuestion() {
        if questionNumber + 1 < quiz.count {
        questionNumber+=1
        } else {
            questionNumber = 0
            print("Correct Questions: \(correctQuestions)")
            print("Wrong Questions: \(wrongQuestions)")
            correctQuestions=0
            wrongQuestions=0
        }
    }
    
    mutating func checkAnswer(_ userAnswer: String) -> Bool {
        if userAnswer == quiz[questionNumber].correct_answer {
            correctQuestions += 1
            return true
        } else {
            wrongQuestions+=1
            return false
        }
    }
}
