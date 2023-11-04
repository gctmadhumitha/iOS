//
//  ViewController.swift
//  Test
//
//  Created by Madhumitha Loganathan on 02/11/23.
//

import UIKit

class ViewController: UIViewController{
    
    private lazy var userLabel : UILabel = {
        let label = UILabel()
        label.text = "User Name"
        return label
    }()
    
    private lazy var passwordLabel : UILabel = {
        let label = UILabel()
        label.text = "Password"
        return label
    }()
    
    private lazy var userText : UITextField = {
       let textfield = UITextField()
        textfield.placeholder = "Enter User name"
        return textfield
    }()
    
    private lazy var passwordText : UITextField = {
       let textfield = UITextField()
       textfield.placeholder = "Enter Password"
       return textfield
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        button.backgroundColor = UIColor.blue
        button.setTitle("Login", for: .normal)
        return button
    }()
    
    private lazy var errorLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = ""
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        
        button.addTarget(self, action: #selector(isValidCredentials), for: .touchUpInside)
               
        let userNameStackView = UIStackView()
        userNameStackView.axis = .horizontal
        userNameStackView.distribution = .fillEqually
        userNameStackView.addArrangedSubview(userLabel)
        userNameStackView.addArrangedSubview(userText)
        
        let passwordStackView = UIStackView()
        passwordStackView.axis = .horizontal
        userNameStackView.distribution = .fillEqually
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordText)
        
        let containerStackView = UIStackView()
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.distribution = .fillProportionally
        containerStackView.addArrangedSubview(userNameStackView)
        containerStackView.addArrangedSubview(passwordStackView)
        containerStackView.addArrangedSubview(button)
        containerStackView.addArrangedSubview(errorLabel)
        
        self.view.addSubview(containerStackView)
        
        
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80),
            containerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            button.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func isValidCredentials(sender: UIButton){
        if let text = userText.text, text.count < 8 {
            errorLabel.isHidden = false
            errorLabel.text = "Please enter 8 characters"
        }
    }
}


