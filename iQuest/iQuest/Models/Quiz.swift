//
//  QuizViewModel.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 13/09/23.
//

import Foundation


class Quiz {
    
    var category : Category = Category(id: 9, name: "General Knowledge")
    var questionNumber = 0
    var correctQuestions = 0
    var wrongQuestions = 0
    var questions: [Question] = []

    func getQuestionsText() -> String {
        return questions[questionNumber].question
    }
    
    func getProgress() -> Float {
        return Float(questionNumber)/Float(questions.count)
    }
    
    func getScore() -> Int {
        return correctQuestions
    }
    
     func nextQuestion() {
         print("questionNumber : \(questionNumber)")
        if questionNumber + 1 < questions.count {
            questionNumber+=1
                
            
        } else {
            questionNumber = 0
            print("Correct Questions: \(correctQuestions)")
            print("Wrong Questions: \(wrongQuestions)")
            correctQuestions=0
            wrongQuestions=0
        }
    }
    
     func checkAnswer(_ userAnswer: String) -> Bool {
        if userAnswer == questions[questionNumber].correct_answer {
            correctQuestions += 1
            return true
        } else {
            wrongQuestions+=1
            return false
        }
    }
    
     func fetchQuestions() async  {
        let serviceResponse = await APIService().fetchQuizFor(category: category.id)
        guard serviceResponse.questions.count != 0  else {
            print("Error Message is", serviceResponse.error)
            return
        }
        questions = serviceResponse.questions
        return 
    }
    

}
