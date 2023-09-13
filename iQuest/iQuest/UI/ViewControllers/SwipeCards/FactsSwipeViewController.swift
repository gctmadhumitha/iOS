//
//  FactsSwipeViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 12/09/23.

import UIKit

class FactsSwipeViewController: UIViewController {

    //MARK: - Properties
    var viewModelData = [FactDataModel(bgColor: UIColor(red:0.96, green:0.81, blue:0.46, alpha:1.0), text: "Hamburger"),
                         FactDataModel(bgColor: UIColor(red:0.29, green:0.64, blue:0.96, alpha:1.0), text: "Puppy"),
                         FactDataModel(bgColor: UIColor(red:0.29, green:0.63, blue:0.49, alpha:1.0), text: "Poop"),
                         FactDataModel(bgColor: UIColor(red:0.69, green:0.52, blue:0.38, alpha:1.0), text: "Panda"),
                         FactDataModel(bgColor: UIColor(red:0.90, green:0.99, blue:0.97, alpha:1.0), text: "Subway"),
                         FactDataModel(bgColor: UIColor(red:0.83, green:0.82, blue:0.69, alpha:1.0), text: "Robot")]
    var stackContainer : StackContainerView!
  
    
    //MARK: - Init
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        stackContainer = StackContainerView()
        view.addSubview(stackContainer)
        configureStackContainer()
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        configureNavigationBarButtonItem()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Expense Tracker"
        stackContainer.dataSource = self
    }
    
 
    //MARK: - Configurations
    func configureStackContainer() {
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        stackContainer.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackContainer.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    func configureNavigationBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetTapped))
    }
    
    //MARK: - Handlers
    @objc func resetTapped() {
        stackContainer.reloadData()
        
    }

}

extension FactsSwipeViewController : SwipeCardsDataSource  {

    func numberOfCardsToShow() -> Int {
        return viewModelData.count
    }
    
    func cardold(at index: Int)  -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource = viewModelData[index]
        Task {
            let response = await APIService().fetchFact()
            guard let fact = response.fact  else {
                print("Error Message is \(response.error)")
                //return (nil, "Error")
                return card
            }
            print("fact is \(fact)")
            return card
        }
        return card
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
