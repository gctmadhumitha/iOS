//
//  CategoryTableViewCell.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 05/09/23.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
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
           // categoryImage.image = UIImage(systemName:"circle")
            let categoryName = category?.name
            let category = categoryName!.split(separator: ":")
            if (category.count > 1) { // Split Entertainment:Comics
                categoryNameLabel.text = String(category[1])
                categoryDescLabel.text = String(category[0])
            }
            
        }
    }
    
    private var categoryNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        label.text = ""
        label.textColor = AppColors.primaryTextColor
        return label
    }()
    
    private var categoryDescLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        label.text = ""
        label.textColor = AppColors.secondaryTextColor
        return label
    }()
    
//    private var categoryImage : UIImageView = {
//        let imgView = UIImageView(image: UIImage(systemName: "star"))
//        imgView.contentMode = .scaleAspectFit
//        imgView.clipsToBounds = true
//        return imgView
//    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
//        addSubview(categoryImage)
        addSubview(categoryNameLabel)
        addSubview(categoryDescLabel)
        
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 2
        self.layer.shadowColor = AppColors.shadowColor?.cgColor ?? UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.borderColor = AppColors.primaryAppColor.cgColor
        self.backgroundColor = UIColor.systemBackground
        
//
//        categoryImage.translatesAutoresizingMaskIntoConstraints = false
//        categoryImage.layer.masksToBounds = false
//        categoryImage.layer.cornerRadius = categoryImage.frame.height/2
//        categoryImage.clipsToBounds = true
        
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryNameLabel.font = .preferredFont(forTextStyle: .headline)
        categoryNameLabel.contentScaleFactor = 2.0
        categoryNameLabel.minimumScaleFactor = 0.5
        categoryNameLabel.text = "ha ha ha"
        
        categoryDescLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryDescLabel.font = .preferredFont(forTextStyle: .caption1)
        categoryDescLabel.text = "blah blah blah"
        setupConstraints()
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            
//            categoryImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
//            categoryImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//            categoryImage.heightAnchor.constraint(equalToConstant: 80),
//            categoryImage.widthAnchor.constraint(equalToConstant: 80),
            
            categoryNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            categoryNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//            categoryNameLabel.leftAnchor.constraint(equalTo: categoryImage.rightAnchor, constant: 30),
            categoryNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 30),
//            categoryNameLabel.widthAnchor.constraint(equalToConstant: frame.size.width/2),
//
            categoryDescLabel.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: 20),
            categoryDescLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//            categoryDescLabel.leftAnchor.constraint(equalTo: categoryImage.rightAnchor, constant: 30),
            categoryDescLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 30),
//            categoryDescLabel.widthAnchor.constraint(equalToConstant: frame.size.width/2),
            categoryDescLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10)
        ])
    }
    
    
}


