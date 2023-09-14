//
//  QuizViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 13/09/23.
//

import UIKit

class QuizViewController: UIViewController {

    var category : String? = "General Knowledge"
    var quizBrain = QuizBrain()
    let haptics=UIImpactFeedbackGenerator()
    
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
        setupUI()
        updateUI()
    }
    
    func setupUI(){
        
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
        
        let stackView = UIStackView(arrangedSubviews: [progressBar, titleStackView,  questionLabel, optionOne, optionTwo, optionThree, optionFour])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)

        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        optionTwo.translatesAutoresizingMaskIntoConstraints = false
        optionTwo.translatesAutoresizingMaskIntoConstraints = false
        optionThree.translatesAutoresizingMaskIntoConstraints = false
        optionFour.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            
            titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            progressBar.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            progressBar.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            progressBar.heightAnchor.constraint(equalToConstant: 30),
            
            questionLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
           
            optionOne.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            optionOne.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            optionOne.heightAnchor.constraint(equalToConstant: 50),
            
            
            optionTwo.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            optionTwo.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            optionTwo.heightAnchor.constraint(equalToConstant: 50),
            
            optionThree.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            optionThree.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            optionThree.heightAnchor.constraint(equalToConstant: 50),
            
            optionFour.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            optionFour.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            optionFour.heightAnchor.constraint(equalToConstant: 50)

        ])
    }

    @objc func didSelectAnswer(_ sender: UIButton) {
        if quizBrain.checkAnswer(sender.currentTitle!){
            haptics.impactOccurred()
            sender.backgroundColor = UIColor.green
        } else {
            haptics.impactOccurred()
            sender.backgroundColor = UIColor.red
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.quizBrain.nextQuestion()
            self.updateUI()
        }
        
        
    }
    
    func updateUI(){
        var answers = (quizBrain.quiz[quizBrain.questionNumber].incorrect_answers)!
        answers.append(quizBrain.quiz[quizBrain.questionNumber].correct_answer!)
        answers = answers.shuffled()
        
        print("answers is \(answers)")
        questionLabel.text = quizBrain.quiz[quizBrain.questionNumber].question
        categoryLabel.text = category
        optionOne.setTitle(answers[0], for: UIControl.State.normal)
        optionTwo.setTitle(answers[1], for: UIControl.State.normal)
        optionThree.setTitle(answers[2], for: UIControl.State.normal)
        optionFour.setTitle(answers[3], for: UIControl.State.normal)
        progressBar.progress =  quizBrain.getProgress()
        scoreLabel.text = "Score: \(quizBrain.correctQuestions)"
        
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
