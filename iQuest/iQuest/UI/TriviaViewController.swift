//
//  TriviaViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 01/09/23.
//

import UIKit

class TriviaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var tableView = UITableView()
    var categories:[Category] = [Category]()
    let cellId = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isEditing = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
        setupConstraints()
        
        Task {
            await setupData()
        }
    }
    
    func setupUI(){
        self.view.addSubview(tableView)
        self.tableView.backgroundColor = .systemTeal
        self.tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.tableView.separatorColor = UIColor.lightGray
    }

    func setupConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //<#code#>
        let questionsVC = QuestionsViewController()
        questionsVC.category = categories[indexPath.row]
        self.navigationController?.pushViewController(questionsVC,animated: true)

    }
    
    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return categories.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryTableViewCell
         let category = categories[indexPath.row]
         cell.category = category
         cell.backgroundColor = UIColor.random
         cell.selectionStyle = UITableViewCell.SelectionStyle.none
         return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
        
    // Override to support editing the table view.
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            categories.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveObject = categories[sourceIndexPath.row]
        categories.remove(at: sourceIndexPath.row)
        categories.insert(moveObject, at: destinationIndexPath.row)
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}

enum CategoryType {
    
    case generalKnowledge
    case history
    case gadgets
}
