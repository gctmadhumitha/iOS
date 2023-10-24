//
//  CustomViewCell.swift
//  MVVM-Basic
//
//  Created by Madhumitha Loganathan on 21/09/23.
//

import Foundation
import UIKit

class CustomViewCell : UITableViewCell {
    
    private lazy var label : UILabel  = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 0
        label.text = "dummy"
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")
        contentView.addSubview(label)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints(){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func configureView(with viewModel: PersonViewModel){
        label.text = "\(viewModel.firstName),\(viewModel.lastName)"
    }
}
