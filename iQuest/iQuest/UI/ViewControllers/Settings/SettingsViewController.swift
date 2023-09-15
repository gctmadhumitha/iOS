//
//  SettingsViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 31/08/23.
//

import UIKit

final class SettingsViewController: UIViewController, ProductSelectionDelegate {

    let productImageView = UIImageView()
    let productNameLabel = UILabel()
    let chooseProductButton = UIButton()
    let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func didSelectProduct(name: String, imageName: String) {
        productNameLabel.text = name
        productImageView.image = UIImage(named: imageName)
    }

    @objc func presentProductSelectionVC(){
        let destinationVC = ProductSelectionViewController()
        destinationVC.delegate = self
        destinationVC.modalPresentationStyle = .pageSheet
        destinationVC.sheetPresentationController?.detents = [.medium()]
        destinationVC.sheetPresentationController?.prefersGrabberVisible = true
        present(destinationVC, animated: true)
    }
    
    func setupUI(){
        view.addSubview(productImageView)
        view.addSubview(productNameLabel)
        view.addSubview(chooseProductButton)
        view.addSubview(nextButton)
        view.backgroundColor = .systemBackground
        navigationItem.title = "Apple products"
        
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        chooseProductButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        productImageView.image = UIImage(named: "gadgets")
        
        productNameLabel.text  = "Apple product line"
        productNameLabel.textAlignment = .center
        productNameLabel.font =     .systemFont(ofSize: 20, weight: .medium)
        productNameLabel.textColor = .darkGray
        
        nextButton.configuration = .tinted()
        nextButton.configuration?.title = "Next"
        nextButton.configuration?.baseBackgroundColor = .purple
        nextButton.configuration?.baseForegroundColor = .white
        nextButton.configuration?.image = UIImage(systemName:"apple.logo")
        nextButton.configuration?.imagePadding = 8
        nextButton.addTarget(self, action: #selector(goToNextVC), for: .touchUpInside)
        
        chooseProductButton.configuration = .tinted()
        chooseProductButton.configuration?.baseBackgroundColor = .magenta
        chooseProductButton.configuration?.baseForegroundColor = .white
        chooseProductButton.configuration?.title = "Choose Product"
        chooseProductButton.configuration?.image = UIImage(systemName:"apple.logo")
        chooseProductButton.configuration?.imagePadding = 8
        chooseProductButton.addTarget(self, action:#selector(presentProductSelectionVC), for: .touchDown)
        
        let padding: CGFloat  = 20
        NSLayoutConstraint.activate([
            productImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            productImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            productImageView.heightAnchor.constraint(equalToConstant: 255),
            productImageView.widthAnchor.constraint(equalToConstant: 300),
            
            productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 70),
            productNameLabel.centerXAnchor.constraint(equalTo: productImageView.centerXAnchor),
            productNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            productNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding),
            
            chooseProductButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            chooseProductButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chooseProductButton.heightAnchor.constraint(equalToConstant: 50),
            chooseProductButton.widthAnchor.constraint(equalToConstant: 260),
            
            nextButton.bottomAnchor.constraint(equalTo: chooseProductButton.topAnchor, constant: -50),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.widthAnchor.constraint(equalToConstant: 260),
        ])
   
    }
    
    @objc func goToNextVC(){
        let vc = TabBarViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

