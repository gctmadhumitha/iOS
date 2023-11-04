//
//  PersonTableViewCell.swift
//  MVVM-Basic-Delegate
//
//  Created by Madhumitha Loganathan on 21/09/23.
//

import Foundation
import UIKit


class  PersonTableViewCell: UITableViewCell {
    
    public static let cellReuseIdentifier = "PersonCell"
    
    lazy var profileImage : UIImageView = {
        let img = UIImageView()
        //img.frame = ct
        img.image = UIImage(systemName: "person")
        img.layer.cornerRadius = 30
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var nameLabel : UILabel =  {
        let label = UILabel()
        label.text = "Name"
        label.backgroundColor = .white
        label.textColor = .gray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var captionLabel : UILabel =  {
        let label = UILabel()
        label.text = "Caption"
        label.backgroundColor = .white
        label.textColor = .gray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTableViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableViewCell()
    {
        contentView.addSubview(profileImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(captionLabel)
        setupConstraints()
    }
    
    func setupConstraints(){
        profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant:10).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: 40).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        
        captionLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: 40).isActive = true
        captionLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        captionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        captionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
    }

}
