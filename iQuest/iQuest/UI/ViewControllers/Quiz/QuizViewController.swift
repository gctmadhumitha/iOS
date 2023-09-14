//
//  QuizViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 13/09/23.
//

import UIKit

class QuizViewController: UIViewController {

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
        label.textAlignment = .left
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
        progressBar.setProgress(0.5, animated: false)
        progressBar.trackTintColor = UIColor.lightGray
        progressBar.tintColor = UIColor.blue
        return progressBar
    }()
    
    private lazy var optionOne: UIButton = {
        return optionButton(title: "Answer 1")
    }()
    
    private lazy var optionTwo: UIButton = {
        return optionButton(title: "Answer 2")
    }()
    
    private lazy var optionThree: UIButton = {
        return optionButton(title: "Answer 3")
    }()
    
    private lazy var optionFour: UIButton = {
        return optionButton(title: "Answer 4")
    }()

    
    func optionButton(title:String) -> UIButton {
        let button  = UIButton(type: .system)
        button.frame = CGRect(x: 20, y: 20, width: 100, height: 50)
        button.setTitle("Option", for: .normal)
        button.tintColor = AppColors.secondaryTextColor
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.backgroundColor = AppColors.buttonColor
        button.layer.cornerRadius = 20
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupQuestionsView()
        setupQuestionsView()
        Task {
            await setupData()
        }
    }
    
    func setupResultsView(){
        resultsStackView.axis = .vertical
        resultsStackView.alignment = .center
        resultsStackView.distribution = .equalSpacing
        resultsStackView.spacing = 20
        resultsStackView.isLayoutMarginsRelativeArrangement = true
        resultsStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        
    }
    
    func setupQuestionsView(){
        
        self.view.backgroundColor = AppColors.primaryBackground
        optionOne.addTarget(self, action: #selector(didSelectAnswer(_ :)), for: .touchUpInside)
        optionTwo.addTarget(self, action: #selector(didSelectAnswer(_ :)), for: .touchUpInside)
        optionThree.addTarget(self, action: #selector(didSelectAnswer(_ :)), for: .touchUpInside)
        optionFour.addTarget(self, action: #selector(didSelectAnswer(_ :)), for: .touchUpInside)
       
        
        let titleStackView = UIStackView(arrangedSubviews: [categoryLabel, scoreLabel])
        titleStackView.axis = .horizontal
        titleStackView.alignment = .trailing
        titleStackView.distribution = .equalSpacing
        titleStackView.spacing = 10
        titleStackView.backgroundColor = .cyan
        
        questionsStackView = UIStackView(arrangedSubviews: [progressBar, titleStackView,  questionLabel, optionOne, optionTwo, optionThree, optionFour])
        questionsStackView.axis = .vertical
        questionsStackView.alignment = .center
        questionsStackView.distribution = .equalSpacing
        questionsStackView.spacing = 20
        questionsStackView.isLayoutMarginsRelativeArrangement = true
        questionsStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)

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
            progressBar.leadingAnchor.constraint(equalTo: questionsStackView.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: questionsStackView.trailingAnchor, constant: -20),
            progressBar.heightAnchor.constraint(equalToConstant: 30),
            
            questionLabel.centerXAnchor.constraint(equalTo: questionsStackView.centerXAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: questionsStackView.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: questionsStackView.trailingAnchor, constant: -20),
           
            optionOne.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            optionOne.centerXAnchor.constraint(equalTo: questionsStackView.centerXAnchor),
            optionOne.heightAnchor.constraint(equalToConstant: 50),
            
            
            optionTwo.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            optionTwo.centerXAnchor.constraint(equalTo: questionsStackView.centerXAnchor),
            optionTwo.heightAnchor.constraint(equalToConstant: 50),
            
            optionThree.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            optionThree.centerXAnchor.constraint(equalTo: questionsStackView.centerXAnchor),
            optionThree.heightAnchor.constraint(equalToConstant: 50),
            
            optionFour.widthAnchor.constraint(equalToConstant: view.frame.width/2),
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.quiz.nextQuestion()
            self.updateUI()
        }
        
        
    }
    
    func setupData() async  {
        let _ = await quiz.fetchQuestions()
        DispatchQueue.main.async { self.updateUI() }
    }
    
    func updateUI(){
        var answers = (quiz.questions[quiz.questionNumber].incorrect_answers)
        answers.append(quiz.questions[quiz.questionNumber].correct_answer)
        answers = answers.shuffled()
        
        print("answers is \(answers)")
        questionLabel.text = quiz.questions[quiz.questionNumber].question
        categoryLabel.text = category.name
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
