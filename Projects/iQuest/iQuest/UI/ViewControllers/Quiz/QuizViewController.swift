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
    
//    private var questionsStackView : UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .center
//        stackView.distribution = .equalSpacing
//        stackView.spacing = 20
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
   
    private var questionsStackView : QuizQuestionsView = {
        let stackView = QuizQuestionsView()
        return stackView
    }()
    
    private var resultsStackView : QuizResultsView = {
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
        
        view.addSubview(resultsStackView)
        view.addSubview(questionsStackView)
        //setupQuestionsView()
        //setupResultsView()
       
    }
    
    
    
    
    func layoutConstraintsForQuestionView(){
        NSLayoutConstraint.activate([
            
            resultsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            
            
            questionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            questionsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            
            titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            progressBar.centerXAnchor.constraint(equalTo: questionsStackView.centerXAnchor),
            progressBar.leadingAnchor.constraint(equalTo: questionsStackView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: questionsStackView.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 10),
            
            questionLabel.centerXAnchor.constraint(equalTo: questionsStackView.centerXAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: questionsStackView.leadingAnchor, constant: 10),
            questionLabel.trailingAnchor.constraint(equalTo: questionsStackView.trailingAnchor, constant: -10),
            
            optionOne.leadingAnchor.constraint(equalTo: questionsStackView.leadingAnchor, constant: 20),
            optionOne.trailingAnchor.constraint(equalTo: questionsStackView.trailingAnchor, constant: -20),
            optionOne.centerXAnchor.constraint(equalTo: questionsStackView.centerXAnchor),
            optionOne.heightAnchor.constraint(equalToConstant: 50),
            
            optionTwo.leadingAnchor.constraint(equalTo: questionsStackView.leadingAnchor,constant: 20),
            optionTwo.trailingAnchor.constraint(equalTo: questionsStackView.trailingAnchor,constant: -20),
            optionTwo.centerXAnchor.constraint(equalTo: questionsStackView.centerXAnchor),
            optionTwo.heightAnchor.constraint(equalToConstant: 50),
            
            optionThree.leadingAnchor.constraint(equalTo: questionsStackView.leadingAnchor, constant: 20),
            optionThree.trailingAnchor.constraint(equalTo: questionsStackView.trailingAnchor, constant: -20),
            optionThree.centerXAnchor.constraint(equalTo: questionsStackView.centerXAnchor),
            optionThree.heightAnchor.constraint(equalToConstant: 50),
            
            optionFour.leadingAnchor.constraint(equalTo: questionsStackView.leadingAnchor, constant: 20),
            optionFour.trailingAnchor.constraint(equalTo: questionsStackView.trailingAnchor, constant: -20),
            optionFour.centerXAnchor.constraint(equalTo: questionsStackView.centerXAnchor),
            optionFour.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
}

extension QuizViewController {

    @objc func didSelectAnswer(_ sender: UIButton) {
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
                self?.showQuestion()
            }

        }
    }

    
    func setupData() async  {
        let _ = await quizvm.fetchQuestions()
        DispatchQueue.main.async { self.showQuestion() }
    }
    
    func showResults() {
        resultsStackView.updateResults(quizvm: quizvm)
        resultsStackView.resultsDelegate = self
        self.resultsStackView.fadeIn()
        self.questionsStackView.fadeOut()
    }
    
    
    
    func showQuestion(){
        var answers = (quizvm.questions[quizvm.questionNumber].incorrect_answers)
        answers.append(quizvm.questions[quizvm.questionNumber].correct_answer)
        answers = answers.shuffled()
        
        print("answers is \(answers)")
        
        questionLabel.text = quizvm.questions[quizvm.questionNumber].question
        categoryLabel.text = category.name
        
        // Don't do the animation for first question
        if quizvm.questionNumber != 0 {
            questionLabel.fadeTransition()
            optionOne.fadeTransition()
            optionTwo.fadeTransition()
            optionThree.fadeTransition()
            optionFour.fadeTransition()
        }
        
        optionOne.setTitle(answers[0], for: UIControl.State.normal)
        optionTwo.setTitle(answers[1], for: UIControl.State.normal)
        optionThree.setTitle(answers[2], for: UIControl.State.normal)
        optionFour.setTitle(answers[3], for: UIControl.State.normal)
        optionOne.backgroundColor = AppColors.yellowColor
        optionTwo.backgroundColor = AppColors.yellowColor
        optionTwo.backgroundColor = AppColors.yellowColor
        optionThree.backgroundColor = AppColors.yellowColor
        optionFour.backgroundColor = AppColors.yellowColor
        progressBar.progress =  quizvm.getProgress()
        scoreLabel.text = "Score: \(quizvm.correctQuestions)"
    }

}


extension QuizViewController {
    func createButton(title:String = "") -> UIButton {
        let button  = UIButton(type: .system)
        button.frame = CGRect(x: 20, y: 20, width: 100, height: 50)
        button.setTitle(title, for: .normal)
        button.tintColor = AppColors.buttonTextColor
        button.titleLabel?.font = AppFonts.buttonFont
        button.backgroundColor = AppColors.yellowColor
        button.layer.cornerRadius = AppConstants.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectAnswer(_ :)), for: .touchUpInside)
        return button
    }
}

extension QuizViewController:  QuizResultsDelegate {
    func didTapTryAgain() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.quizvm.nextQuestion()
            self?.showQuestion()
            self?.resultsStackView.fadeOut()
            self?.questionsStackView.fadeIn()
        }
    }
    
    func didTapGoBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
