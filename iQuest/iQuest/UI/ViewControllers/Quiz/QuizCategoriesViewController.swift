//
//  TriviaViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 01/09/23.
//

import UIKit

final class QuizCategoriesViewController: UIViewController {
   
    private var titleView = UIView()
    private var tableView = UITableView()
    private var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.text = ""
        label.textColor = AppColors.primaryTextColor
        return label
    }()
    
    private var categories:[Category] = [Category]()
    private let cellId = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
        setupConstraints()
        Task {
            await setupData()
        }
    }

}

extension QuizCategoriesViewController {
    
    func setupUI(){
        self.view.backgroundColor = AppColors.primaryBackground
        self.titleView.addSubview(titleLabel)
        self.view.addSubview(titleView)
        self.view.addSubview(tableView)
        
        self.titleLabel.text = "Trivia"
        self.tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }

    func setupConstraints(){
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
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            titleView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            
        ])
    }
    
    func setupData() async {
//        categories.append(Category(name: "Glasses", image: "circle" , desc: "This is best Glasses I've ever seen"))
//        categories.append(Category(name: "Desert", image: "square" , desc: "This is so yummy"))
//        categories.append(Category(name: "Camera Lens", image: "star", desc: "I wish I had this camera lens"))
        let serviceResponse = await APIService().fetchTriviaCategories()
        guard let trivia_categories = serviceResponse.categories?.trivia_categories, trivia_categories.count != 0  else{
            print("Error Message is \(serviceResponse.error)")
            return
        }
        categories = trivia_categories
        
        DispatchQueue.main.async { self.tableView.reloadData() }
        
    }
}

extension QuizCategoriesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //<#code#>
        let questionsVC = QuizViewController()
        questionsVC.category = categories[indexPath.section].name
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
         let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryTableViewCell
         let category = categories[indexPath.section]
         cell.category = category
         cell.selectionStyle = UITableViewCell.SelectionStyle.none
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
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveObject = categories[sourceIndexPath.section]
        categories.remove(at: sourceIndexPath.section)
        categories.insert(moveObject, at: destinationIndexPath.section)
        
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
