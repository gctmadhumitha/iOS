//
//  QuizQuestionsView.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 29/09/23.
//

import UIKit

protocol QuizQuestionsDelegate: AnyObject {
    func didSelectAnswer(sender: UIButton)
}

class QuizQuestionsView: UIStackView {
    
    weak var questionsDelegate: QuizQuestionsDelegate?
    
    private var titleStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var headerLabel : UILabel = {
        let label = UILabel()
        label.font = AppFonts.titleFont
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.text = "Quiz"
        label.textColor = AppColors.primaryTextColor
        return label
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
        progressBar.progressTintColor = AppColors.gradientColor1
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.setProgress(0.5, animated: true)
        progressBar.trackTintColor = UIColor.systemGray
        progressBar.layer.cornerRadius = 4
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 5
        progressBar.subviews[1].clipsToBounds = true
        return progressBar
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension QuizQuestionsView {
    
    func layoutUI(){
        self.axis = .vertical
        self.alignment = .center
        self.distribution = .equalSpacing
        self.spacing = 20
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addArrangedSubview(headerLabel)
        self.addArrangedSubview(titleStackView)
        self.addArrangedSubview(progressBar)
        self.addArrangedSubview(questionLabel)
        self.addArrangedSubview(optionOne)
        self.addArrangedSubview(optionTwo)
        self.addArrangedSubview(optionThree)
        self.addArrangedSubview(optionFour)
        
        titleStackView.addArrangedSubview(categoryLabel)
        titleStackView.addArrangedSubview(scoreLabel)
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillEqually
        titleStackView.spacing = 20
        
        NSLayoutConstraint.activate([
            
            titleStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        
            progressBar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 10),
            
            questionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            questionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            optionOne.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            optionOne.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            optionOne.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            optionOne.heightAnchor.constraint(equalToConstant: 50),
            
            optionTwo.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            optionTwo.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20),
            optionTwo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            optionTwo.heightAnchor.constraint(equalToConstant: 50),
            
            optionThree.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            optionThree.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            optionThree.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            optionThree.heightAnchor.constraint(equalToConstant: 50),
            
            optionFour.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            optionFour.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            optionFour.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            optionFour.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    func updateQuestion(quizvm: QuizViewModel){
        var answers = (quizvm.questions[quizvm.questionNumber].incorrect_answers)
        answers.append(quizvm.questions[quizvm.questionNumber].correct_answer)
        answers = answers.shuffled()
        
        print("answers is \(answers)")
        
        questionLabel.text = quizvm.questions[quizvm.questionNumber].question
        categoryLabel.text = quizvm.category.name
        
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
    
    @objc func didSelectAnswer(_ sender: UIButton) {
        questionsDelegate?.didSelectAnswer(sender: sender)
    }
}
