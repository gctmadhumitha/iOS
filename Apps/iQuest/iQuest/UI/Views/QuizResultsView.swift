//
//  QuizResultsView.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 29/09/23.
//

import UIKit

protocol QuizResultsDelegate: AnyObject {
    func didTapTryAgain()
    func didTapGoBack()
}

class QuizResultsView: UIStackView {


    weak var resultsDelegate : QuizResultsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private var resultsButtonView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    private var resultsHeaderLabel : UILabel = {
        let label = UILabel()
        label.font = AppFonts.titleFont
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.text = "QuizQuester"
        label.textColor = AppColors.primaryTextColor
        return label
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
    
}

extension QuizResultsView {
    
    func layoutUI(){
        
        self.isHidden = true
        self.axis = .vertical
        self.alignment = .center
        self.distribution = .equalSpacing
        self.spacing = 20
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        
        resultsButtonView.addArrangedSubview(tryAgainButton)
        resultsButtonView.addArrangedSubview(goBackButton)
        
        self.addArrangedSubview(resultsHeaderLabel)
        self.addArrangedSubview(resultsMessageLabel)
        self.addArrangedSubview(resultsLabel)
        self.addArrangedSubview(resultsButtonView)
        self.translatesAutoresizingMaskIntoConstraints = false
        resultsMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        resultsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tryAgainButton.setTitle("Play Again", for: .normal)
        tryAgainButton.addTarget(self, action: #selector(didTryAgain(_ :)), for: .touchUpInside)
        
        goBackButton.addTarget(self, action: #selector(didGoBack(_ :)), for: .touchUpInside)
        goBackButton.setTitle("Go back", for: .normal)
        tryAgainButton.setTitle("Play again", for: .normal)
        
        layoutConstraintsForResultsView()
        
    }
    
    func layoutConstraintsForResultsView() {
        NSLayoutConstraint.activate([
      
            resultsHeaderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            resultsHeaderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            resultsMessageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            resultsMessageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            resultsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            resultsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            resultsButtonView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            resultsButtonView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            resultsButtonView.topAnchor.constraint(equalTo: resultsLabel.bottomAnchor, constant: 40),
            
            tryAgainButton.leadingAnchor.constraint(equalTo: resultsButtonView.leadingAnchor, constant: 10),
            tryAgainButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tryAgainButton.heightAnchor.constraint(equalToConstant: AppConstants.buttonWidth),
            tryAgainButton.widthAnchor.constraint(equalToConstant: self.frame.width/2),
            
            goBackButton.leadingAnchor.constraint(equalTo: resultsButtonView.leadingAnchor, constant: 10),
            goBackButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            goBackButton.widthAnchor.constraint(equalToConstant: self.frame.width/2),
            goBackButton.heightAnchor.constraint(equalToConstant: AppConstants.buttonWidth)
        ])
        
    }
    
    @objc func didTryAgain(_ sender: UIButton) {
        self.resultsDelegate?.didTapTryAgain()
    }
    
    @objc func didGoBack(_ sender: UIButton) {
        self.resultsDelegate?.didTapGoBack()
    }
    
}
    
extension QuizResultsView {
    func updateResults(quizvm : QuizViewModel){
        resultsLabel.text = "You have scored \(quizvm.correctQuestions)/\(quizvm.totalNumberOfQuestions) in the category - \(quizvm.category.name)."
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
        return button
    }
}
