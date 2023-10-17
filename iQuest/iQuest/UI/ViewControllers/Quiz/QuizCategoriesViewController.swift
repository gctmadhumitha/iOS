//
//  TriviaViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 01/09/23.
//

import UIKit

final class QuizCategoriesViewController: UIViewController {
   
    private var titleView = UIView()
    private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(QuizCategoryTableViewCell.self, forCellReuseIdentifier: QuizCategoryTableViewCell.cellId)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = AppColors.secondaryBackground
        return tableView
    }()
    
    private var titleLabel : UILabel = {
        let label = UILabel()
        label.font = AppFonts.titleFont
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.text = "Quiz"
        label.textColor = AppColors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var titleTextLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2).bold()
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.text = "Pick your favorite category"
        label.textColor = AppColors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var categories:[Category] = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = AppColors.primaryAppColor;
        setupUI()
        setupData()
    }
}


extension QuizCategoriesViewController {
    
    func setupUI(){
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(titleView)
        view.addSubview(tableView)
        setupTitle()
        setupTableView()
    }

    func setupTitle(){
        titleView.addSubview(titleLabel)
        titleView.addSubview(titleTextLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            titleTextLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 20),
            titleTextLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -20),
            titleTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleTextLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0),
        ])
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            titleView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0)
        ])
        
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    func setupData()  {
        Task {
            let serviceResponse = await APIService().fetchQuizCategories()
            guard let trivia_categories = serviceResponse.categories?.trivia_categories, trivia_categories.count != 0  else{
                print("Error Message is \(serviceResponse.error)")
                return
            }
            categories = trivia_categories
            
            self.tableView.reloadData()
        }
        
    }
}

extension QuizCategoriesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let questionsVC = QuizViewController()
        questionsVC.category = categories[indexPath.section]
        self.navigationController?.pushViewController(questionsVC,animated: true)
    }
    
    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories.count
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return 1
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: QuizCategoryTableViewCell.cellId, for: indexPath) as! QuizCategoryTableViewCell
         let category = categories[indexPath.section]
         cell.category = category
         cell.selectionStyle = .none
         return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
   

}
