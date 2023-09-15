//
//  ProductSeclectionViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 31/08/23.
//

import UIKit

protocol ProductSelectionDelegate {
    func didSelectProduct(name: String, imageName: String)
}

final class ProductSelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    var delegate: ProductSelectionDelegate?
    
    let iPhoneButton = UIButton()
    let iPadButton = UIButton()
    let macBookButton = UIButton()
    
    // Setup view components and autolayout constraints
    func setupUI(){
        view.addSubview(iPhoneButton)
        view.addSubview(iPadButton)
        view.addSubview(macBookButton)
        view.backgroundColor = .systemBackground
        
        iPhoneButton.translatesAutoresizingMaskIntoConstraints = false
        iPadButton.translatesAutoresizingMaskIntoConstraints = false
        macBookButton.translatesAutoresizingMaskIntoConstraints = false
        
        iPhoneButton.configuration = .tinted()
        iPhoneButton.configuration?.title = "iPhone"
        iPhoneButton.configuration?.image = UIImage(systemName: "iphone")
        iPhoneButton.configuration?.imagePadding = 8
        iPhoneButton.configuration?.baseForegroundColor = .systemBlue
        iPhoneButton.configuration?.baseBackgroundColor = .systemBlue
        iPhoneButton.addTarget(self, action: #selector(iPhoneButtonTapped), for: .touchUpInside)
        
        iPadButton.configuration = .tinted()
        iPadButton.configuration?.title = "iPad"
        iPadButton.configuration?.image = UIImage(systemName: "ipad")
        iPadButton.configuration?.imagePadding = 8
        iPadButton.configuration?.baseForegroundColor = .systemGreen
        iPadButton.configuration?.baseBackgroundColor = .systemGreen
        iPadButton.addTarget(self, action: #selector(iPadButtonTapped), for: .touchUpInside)
        
        macBookButton.configuration = .tinted()
        macBookButton.configuration?.title = "MacBook"
        macBookButton.configuration?.image = UIImage(systemName: "laptopcomputer")
        macBookButton.configuration?.imagePadding = 8
        macBookButton.configuration?.baseForegroundColor = .systemIndigo
        macBookButton.configuration?.baseBackgroundColor = .systemIndigo
        macBookButton.addTarget(self, action: #selector(macBookButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            iPadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iPadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iPadButton.heightAnchor.constraint(equalToConstant: 50),
            iPadButton.widthAnchor.constraint(equalToConstant: 280),
            
            iPhoneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iPhoneButton.bottomAnchor.constraint(equalTo: iPadButton.topAnchor, constant: -20),
            iPhoneButton.heightAnchor.constraint(equalToConstant: 50),
            iPhoneButton.widthAnchor.constraint(equalToConstant: 280),
            
            macBookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            macBookButton.topAnchor.constraint(equalTo: iPadButton.bottomAnchor, constant: 20),
            macBookButton.heightAnchor.constraint(equalToConstant: 50),
            macBookButton.widthAnchor.constraint(equalToConstant: 280),
            
        ])
        
    }
    
    @objc func iPhoneButtonTapped(){
        delegate?.didSelectProduct(name: "iPhone 14", imageName: "iphone")
        dismiss(animated: true)
    }
    
    @objc func iPadButtonTapped(){
        delegate?.didSelectProduct(name: "iPad 7", imageName: "ipad")
        dismiss(animated: true)
    }
    
    @objc func macBookButtonTapped(){
        delegate?.didSelectProduct(name: "MacBook Pro", imageName: "macbook")
        dismiss(animated: true)
    }

}
