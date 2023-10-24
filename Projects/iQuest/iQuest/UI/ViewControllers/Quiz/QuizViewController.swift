//
//  QuizViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 13/09/23.
//

import UIKit

final class QuizViewController: UIViewController {
    
    var category : Category = Category(id: 9, name: "General Knowledge")
    var quizvm = QuizViewModel()
    let haptics = UIImpactFeedbackGenerator()
   
    private var questionsView : QuizQuestionsView = {
        let stackView = QuizQuestionsView()
        return stackView
    }()
    
    private var resultsView : QuizResultsView = {
        let stackView = QuizResultsView()
        return stackView
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColors.primaryBackground
        layoutUI()
        Task {
            await setupData()
        }
    }
    
}

extension QuizViewController {
    
    func layoutUI(){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        view.addSubview(resultsView)
        view.addSubview(questionsView)
        resultsView.resultsDelegate = self
        questionsView.questionsDelegate = self
        layoutConstraints()
    }
    
    func layoutConstraints(){
        NSLayoutConstraint.activate([
            
            resultsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
    
            questionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            questionsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
 
        ])
    }
}

extension QuizViewController: QuizQuestionsDelegate {

    func didSelectAnswer(sender: UIButton) {
        if quizvm.checkAnswer(sender.currentTitle!){
            haptics.impactOccurred()
            sender.backgroundColor = AppColors.gradientColor1
        } else {
            haptics.impactOccurred()
            sender.backgroundColor = AppColors.redColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            let qno = self?.quizvm.questionNumber ?? 0
            if(qno + 1 == self?.quizvm.totalNumberOfQuestions) {
                self?.showResults()
            }
            else {
                self?.quizvm.nextQuestion()
                self?.showQuestions()
            }

        }
    }
    
    func setupData() async  {
        let _ = await quizvm.fetchQuestions()
        DispatchQueue.main.async { self.showQuestions() }
    }
    
    func showQuestions() {
        questionsView.updateQuestion(quizvm: quizvm)
    }
    
    func showResults() {
        resultsView.updateResults(quizvm: quizvm)
        resultsView.resultsDelegate = self
        self.resultsView.fadeIn()
        self.questionsView.fadeOut()
    }

}


extension QuizViewController:  QuizResultsDelegate {
    func didTapTryAgain() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.quizvm.nextQuestion()
            self?.showQuestions()
            self?.resultsView.fadeOut()
            self?.questionsView.fadeIn()
        }
    }
    
    func didTapGoBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
