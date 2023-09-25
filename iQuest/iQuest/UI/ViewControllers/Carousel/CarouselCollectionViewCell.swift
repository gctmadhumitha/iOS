//
//  CarouselCollectionViewCell.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 11/09/23.
//

import UIKit

final class CarouselCollectionViewCell: UICollectionViewCell {
    
    // MARK: - SubViews
    private lazy var imageView : UIImageView =  {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var captionLabel : UILabel = {
        let captionLabel = UILabel()
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.textAlignment = .center
        captionLabel.font = UIFont.preferredFont(forTextStyle: .title2).bold()
        captionLabel.textColor = .white
        return captionLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        descriptionLabel.textColor = .white
        return descriptionLabel
    }()
    
    // MARK: - Properties
    
    static let cellId = "CarouselCell"
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension CarouselCollectionViewCell {
    func layoutViews() {
        backgroundColor = UIColor.clear
        addSubview(imageView)
        addSubview(captionLabel)
        addSubview(descriptionLabel)
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.frame.height * 0.8).isActive = true
       
        captionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        captionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.sizeToFit()
        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        //descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 3.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        //self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.layer.shadowRadius = 2.0
//        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 2.0
       // self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}

// MARK: - Public

extension CarouselCollectionViewCell {
    public func configure(image: UIImage?, caption: String, description: String) {
        imageView.image = image
        captionLabel.text = caption
        descriptionLabel.text = description
    }
}

