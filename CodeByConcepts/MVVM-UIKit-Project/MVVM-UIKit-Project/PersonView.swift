//
//  PersonView.swift
//  MVVM-UIKit-Project
//
//  Created by Madhumitha Loganathan on 26/09/23.
//

import UIKit

class PersonView: UIView {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var subscribeBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Tap Me".uppercased()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .red
        config.cornerStyle = .medium
        
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapSubscribe), for: .touchUpInside)
        return btn
    }()
    
    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "XXX"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var emailLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "XXX@gmail.com"
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private lazy var personStackView : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
       return stackView
    }()
    
    private var action:()-> ()
    
    init(action: @escaping ()->() ){
        self.action = action
        super.init(frame: .zero)
        setup()
    }
    
    func set(name:String, email:String) {
        print("set called")
        nameLabel.text = name
        emailLabel.text = email
    }
}


private extension PersonView{
    
    func setup(){
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        self.layer.cornerRadius =  10
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(personStackView)
        
        personStackView.addArrangedSubview(nameLabel)
        personStackView.addArrangedSubview(emailLabel)
        personStackView.addArrangedSubview(subscribeBtn)
        
        NSLayoutConstraint.activate([
            personStackView.topAnchor.constraint(equalTo: self.topAnchor, constant:8),
            personStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:-8),
            personStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            personStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            
        ])
            
    }
    
    @objc func didTapSubscribe(sender: UIButton){
        print("didTapSubscribe button")
        self.action()
    }
    
}


