//
//  QuizViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 13/09/23.
//

import UIKit

final class QuizViewController: UIViewController {

    var category : Category = Category(id: 9, name: "General Knowledge")
    var quiz = Quiz()
    let haptics=UIImpactFeedbackGenerator()
    
    private var questionsStackView : UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private var resultsStackView : UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    private var categoryLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.text = ""
        label.textColor = AppColors.primaryTextColor
        return label
    }()
    
    private var scoreLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .right
        label.text = ""
        label.textColor = AppColors.primaryTextColor
        return label
    }()
    
    private var questionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1).bold()
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.text = ""
        label.textColor = AppColors.primaryTextColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var progressBar : UIProgressView = {
       let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.progressTintColor = AppColors.secondaryAppColor
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.setProgress(0.5, animated: true)
        progressBar.trackTintColor = UIColor.lightGray
        progressBar.layer.cornerRadius = 10
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 15
        progressBar.subviews[1].clipsToBounds = true
        return progressBar
    }()
    
    private var resultsMessageLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.text = "Congratulations! You have completed your Quiz."
        label.numberOfLines = 0
        label.textColor = AppColors.primaryTextColor
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var resultsLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.text = ""
        label.numberOfLines = 0
        label.textColor = AppColors.primaryTextColor
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var tryAgainButton: UIButton = {
        return createButton()
    }()
    
    private lazy var goBackButton: UIButton = {
        return createButton()
    }()
    
    private lazy var optionOne: UIButton = {
        return createButton()
    }()
    
    private lazy var optionTwo: UIButton = {
        return createButton()
    }()
    
    private lazy var optionThree: UIButton = {
        return createButton()
    }()
    
    private lazy var optionFour: UIButton = {
        return createButton()
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        setupQuestionsView()
        setupResultsView()
        Task {
            await setupData()
        }
    }
    
    func setupResultsView(){
        view.addSubview(resultsStackView)
        
        let buttonsView = UIStackView(arrangedSubviews: [tryAgainButton, goBackButton])
        buttonsView.axis = .vertical
        buttonsView.alignment = .center
        buttonsView.distribution = .equalSpacing
        buttonsView.spacing = 10
        
        resultsStackView.isHidden = true
        resultsStackView.axis = .vertical
        resultsStackView.alignment = .center
        resultsStackView.distribution = .equalSpacing
        resultsStackView.spacing = 20
        resultsStackView.isLayoutMarginsRelativeArrangement = true
        resultsStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        resultsStackView.addArrangedSubview(resultsMessageLabel)
        resultsStackView.addArrangedSubview(resultsLabel)
        resultsStackView.addArrangedSubview(buttonsView)
        resultsStackView.translatesAutoresizingMaskIntoConstraints = false
        resultsMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        resultsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tryAgainButton.setTitle("Play Again", for: .normal)
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        tryAgainButton.addTarget(self, action: #selector(didTryAgain(_ :)), for: .touchUpInside)
        
        goBackButton.translatesAutoresizingMaskIntoConstraints = false
        goBackButton.addTarget(self, action: #selector(didGoBack(_ :)), for: .touchUpInside)
        tryAgainButton.setTitle("Go Back", for: .normal)
        
        NSLayoutConstraint.activate([
           
            resultsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            
            resultsMessageLabel.leadingAnchor.constraint(equalTo: resultsStackView.leadingAnchor, constant: 20),
            resultsMessageLabel.trailingAnchor.constraint(equalTo: resultsStackView.trailingAnchor, constant: -20),
            resultsMessageLabel.topAnchor.constraint(equalTo: resultsStackView.topAnchor, constant: 80),
            
            resultsLabel.leadingAnchor.constraint(equalTo: resultsStackView.leadingAnchor, constant: 20),
            resultsLabel.trailingAnchor.constraint(equalTo: resultsStackView.trailingAnchor, constant: -20),
            resultsLabel.topAnchor.constraint(equalTo: resultsLabel.topAnchor, constant: 20),
            
            buttonsView.leadingAnchor.constraint(equalTo: resultsStackView.leadingAnchor, constant: 20),
            buttonsView.trailingAnchor.constraint(equalTo: resultsStackView.trailingAnchor, constant: -20),
            buttonsView.topAnchor.constraint(equalTo: resultsLabel.bottomAnchor, constant: 40),
            
            tryAgainButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor, constant: 10),
            tryAgainButton.centerXAnchor.constraint(equalTo: resultsStackView.centerXAnchor),
            tryAgainButton.heightAnchor.constraint(equalToConstant: Constants.buttonWidth),
            tryAgainButton.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            
            goBackButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor, constant: 10),
            goBackButton.centerXAnchor.constraint(equalTo: resultsStackView.centerXAnchor),
            goBackButton.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            goBackButton.heightAnchor.constraint(equalToConstant: Constants.buttonWidth)
        ])
    }
    
    func setupQuestionsView(){
        
        optionOne.addTarget(self, action: #selector(didSelectAnswer(_ :)), for: .touchUpInside)
        optionTwo.addTarget(self, action: #selector(didSelectAnswer(_ :)), for: .touchUpInside)
        optionThree.addTarget(self, action: #selector(didSelectAnswer(_ :)), for: .touchUpInside)
        optionFour.addTarget(self, action: #selector(didSelectAnswer(_ :)), for: .touchUpInside)
       
        
        let titleStackView = UIStackView(arrangedSubviews: [categoryLabel, scoreLabel])
        titleStackView.axis = .horizontal
        //titleStackView.alignment = .trailing
        titleStackView.distribution = .fillEqually
        titleStackView.spacing = 20
       
        questionsStackView = UIStackView(arrangedSubviews: [progressBar, titleStackView,  questionLabel, optionOne, optionTwo, optionThree, optionFour])
        questionsStackView.axis = .vertical
        questionsStackView.alignment = .center
        questionsStackView.distribution = .equalSpacing
        questionsStackView.spacing = 20
        questionsStackView.isLayoutMarginsRelativeArrangement = true
        questionsStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        questionsStackView.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(questionsStackView)
        questionsStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        optionTwo.translatesAutoresizingMaskIntoConstraints = false
        optionTwo.translatesAutoresizingMaskIntoConstraints = false
        optionThree.translatesAutoresizingMaskIntoConstraints = false
        optionFour.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           
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
    

    @objc func didSelectAnswer(_ sender: UIButton) {
        if quiz.checkAnswer(sender.currentTitle!){
            haptics.impactOccurred()
            sender.backgroundColor = UIColor.green
        } else {
            haptics.impactOccurred()
            sender.backgroundColor = UIColor.red
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            let qno = self?.quiz.questionNumber ?? 0
            if(qno + 1 == self?.quiz.totalNumberOfQuestions) {
                self?.showResults()
            }
            else {
                self?.quiz.nextQuestion()
                self?.showQuestion()
            }

        }
    }
    
    @objc func didTryAgain(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.quiz.nextQuestion()
            self?.showQuestion()
            self?.resultsStackView.fadeOut()
            self?.questionsStackView.fadeIn()
            
        }
    }
    
    @objc func didGoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupData() async  {
        let _ = await quiz.fetchQuestions()
        DispatchQueue.main.async { self.showQuestion() }
    }
    
    func showResults() {
        resultsLabel.text = "You have scored \(quiz.correctQuestions)/\(quiz.totalNumberOfQuestions) in the category - \(quiz.category.name)."
        
        self.resultsStackView.fadeIn()
        self.questionsStackView.fadeOut()
    }
    
    
    
    func showQuestion(){
        var answers = (quiz.questions[quiz.questionNumber].incorrect_answers)
        answers.append(quiz.questions[quiz.questionNumber].correct_answer)
        answers = answers.shuffled()
        
        print("answers is \(answers)")
        
        questionLabel.text = quiz.questions[quiz.questionNumber].question
        categoryLabel.text = category.name
        
        // Don't do the animation for first question
        if quiz.questionNumber != 0 {
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
        optionOne.backgroundColor = AppColors.buttonColor
        optionTwo.backgroundColor = AppColors.buttonColor
        optionThree.backgroundColor = AppColors.buttonColor
        optionFour.backgroundColor = AppColors.buttonColor
        progressBar.progress =  quiz.getProgress()
        scoreLabel.text = "Score: \(quiz.correctQuestions)"
    }

}


extension QuizViewController {
    func createButton(title:String = "") -> UIButton {
        let button  = UIButton(type: .system)
        button.frame = CGRect(x: 20, y: 20, width: 100, height: 50)
        button.setTitle(title, for: .normal)
        button.tintColor = AppColors.buttonTextColor
        button.titleLabel?.font = AppFonts.buttonFont
        button.backgroundColor = AppColors.buttonColor
        button.layer.cornerRadius = 20
        return button
    }
}
