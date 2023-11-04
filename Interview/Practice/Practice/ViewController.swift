//
//  ViewController.swift
//  Practice
//
//  Created by Madhumitha Loganathan on 30/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private lazy var button: UIButton = {
        let button  = UIButton()
        button.backgroundColor = .cyan
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor.purple
        config.image = UIImage(systemName: "car")
        config.imagePlacement = .trailing
        config.title = "Practice"
        config.subtitle = "subtitle"
        button.configuration = config
        return button
    }()
    
    private lazy var textfield : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter text"
        return textField
    }()
    
    
    private lazy var imageView : UIImageView = {
        let image = UIImage(systemName: "star")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This property is nil by default. Assigning a new value to this property also replaces the value of the attributedText property with the same text, although without any inherent style attributes. Instead the label styles the new string using shadowColor, textAlignment, and other style-related properties of the class.This property is nil by default. Assigning a new value to this property also replaces the value of the attributedText property with the same text, although without any inherent style attributes. Instead the label styles the new string using shadowColor, textAlignment, and other style-related properties of the class.This property is nil by default. Assigning a new value to this property also replaces the value of the attributedText property with the same text, although without any inherent style attributes. Instead the label styles the new string using shadowColor, textAlignment, and other style-related properties of the class."
        label.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    func setupUI(){
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        self.view.addSubview(scrollView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(textfield)
        stackView.addArrangedSubview(label)
        scrollView.addSubview(stackView)
        setupConstraints()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            button.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 180),
            
            textfield.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            textfield.heightAnchor.constraint(equalToConstant: 50),
            textfield.widthAnchor.constraint(equalToConstant: 200),
            
            label.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            label.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    @objc func didTapButton(sender: UIButton) {
        let vc = AnotherViewController()
        // can also use .formSheet and result will be the same on the iPhone
        vc.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *),
            let sheet = vc.sheetPresentationController
        {
            sheet.detents = [.medium(), .large()]
        }
        present(vc, animated: true, completion: nil)
    }
    
        
    
}

