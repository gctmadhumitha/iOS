//
//  FactsViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 12/09/23.

import UIKit

final class FactsViewController: UIViewController {
    
    //MARK: - Properties
    
    private var titleView = UIView()
    private lazy var stackContainer : StackContainerView = {
        return StackContainerView()
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        label.textAlignment = .center
        label.text = "Did You Know?"
        label.textColor = AppColors.primaryTextColor
        return label
    }()
    
    //MARK: - Init
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = AppColors.primaryBackground
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackContainer.dataSource = self
    }
    
}

// UI Setup
extension FactsViewController {
    
    //MARK: - Configurations
    
    func setupUI(){
        setupTitle()
        setupStackContainer()
    }
    
    func setupStackContainer() {
        view.addSubview(stackContainer)
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        stackContainer.widthAnchor.constraint(equalToConstant: 320).isActive = true
        stackContainer.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func setupTitle(){
        view.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleLabel.text = "Did you Know!"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
        ])
    }
}

// Swipe Cardview Setup

extension FactsViewController : SwipeCardsDataSource  {

    func numberOfCardsToShow() -> Int {
        return 3
    }
    
    func card() async -> SwipeCardView  {
        let card = SwipeCardView()
        let response = await APIService().fetchFact()
        guard let fact = response.fact  else {
            print("Error Message is \(response.error)")
            return card
        }
        card.dataSource = FactDataModel(bgColor: UIColor(red:0.96, green:0.81, blue:0.46, alpha:1.0), text: fact.text)
        print("fact is \(fact)")
        return card
        
    }
    
    func emptyView() -> UIView? {
        return nil
    }
    

}
