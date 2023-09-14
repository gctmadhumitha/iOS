//
//  FactsViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 12/09/23.

import UIKit

class FactsViewController: UIViewController {

    //MARK: - Properties
    private lazy var stackContainer : StackContainerView = {
        return StackContainerView()
    }()
  
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        label.text = "Do You Know"
        label.textColor = AppColors.primaryTextColor
        return label
    }()
    
    //MARK: - Init
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        stackContainer = StackContainerView()
        
        setupUI()
        configureNavigationBarButtonItem()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        stackContainer.dataSource = self
    }
    
 
    //MARK: - Configurations
    
    func setupUI(){
        configureTitle()
        configureStackContainer()
    }
    func configureStackContainer() {
        view.addSubview(stackContainer)
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        stackContainer.widthAnchor.constraint(equalToConstant: 320).isActive = true
        stackContainer.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    
    func configureTitle(){
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
    }
    
    
    func configureNavigationBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetTapped))
    }
    
    //MARK: - Handlers
    @objc func resetTapped() {
        stackContainer.reloadData()
        
    }

}

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
