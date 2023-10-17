//
//  QuizQuestionsView.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 29/09/23.
//

import UIKit

class QuizQuestionsView: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
    
    
    
    func layoutUI(){
        self.axis = .vertical
        self.alignment = .center
        self.distribution = .equalSpacing
        self.spacing = 20
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }

}
