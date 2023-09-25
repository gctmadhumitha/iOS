//
//  CategoryTableViewCell.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 05/09/23.
//

import UIKit

final class QuizCategoryTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    var category: Category? {
        didSet {
            let categoryName = category?.name
            let category = categoryName!.split(separator: ":")
            if (category.count > 1) { // Split Entertainment:Comics
                categoryNameLabel.text = String(category[1])
                categoryDescLabel.text = String(category[0])
            } else {
                categoryNameLabel.text = String(category[0])
                categoryDescLabel.text = String(category[0])
            }
        }
    }
    
    private lazy var categoryNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        label.text = ""
        label.textColor = AppColors.primaryTextColor
        return label
    }()
    
    private lazy var categoryDescLabel : UILabel = {
        let label = UILabel()
        label.font = AppFonts.buttonFont
        label.textAlignment = .left
        label.text = ""
        label.textColor = AppColors.secondaryTextColor
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        addSubview(categoryNameLabel)
        addSubview(categoryDescLabel)
        
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 2
        self.layer.shadowColor = AppColors.shadowColor?.cgColor ?? UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.borderColor = AppColors.primaryAppColor.cgColor
        self.backgroundColor = AppColors.secondaryBackground
        
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryNameLabel.numberOfLines = 0
        categoryNameLabel.font = .preferredFont(forTextStyle: .headline)
        categoryNameLabel.contentScaleFactor = 2.0
        categoryNameLabel.minimumScaleFactor = 0.5
        //categoryNameLabel.text = "ha ha ha"
        
        categoryDescLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryDescLabel.numberOfLines = 0
        categoryDescLabel.font = .preferredFont(forTextStyle: .caption1)
        //categoryDescLabel.text = "blah blah blah"
        setupConstraints()
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            categoryNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            categoryNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            categoryNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            categoryDescLabel.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: 10),
            categoryDescLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            categoryDescLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            categoryDescLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    
}


