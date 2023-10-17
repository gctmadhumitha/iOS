//
//  ViewController.swift
//  MVVM-Basic-Delegate
//
//  Created by Madhumitha Loganathan on 21/09/23.
//

import UIKit




class ViewController: UIViewController {

    private var models = [Person]()
    
    private lazy var tableView : UITableView = {
       let tableView = UITableView()
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.cellReuseIdentifier)
       return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        setupTable()
    }

    func setupTable(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }
    
    func configureModels(){
        models = [Person(firstName: "John", lastName: "Smith", middleName: "M", birthDate:            Date(), address: "123 Wembley", gender: Gender.male),
                  Person(firstName: "Dave", lastName: "Smith", middleName: "M", birthDate: Date(), address: "123 Wembley", gender: Gender.male),
                  Person(firstName: "Bill", lastName: "Smith", middleName: "M", birthDate: Date(), address: "123 Wembley", gender: Gender.male)]
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.cellReuseIdentifier, for: indexPath) as? PersonTableViewCell else {
            fatalError()
        }
        cell.nameLabel.text = models[indexPath.row].firstName
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

