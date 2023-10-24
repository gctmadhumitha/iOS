//
//  ViewController.swift
//  MVVM-Basic
//
//  Created by Madhumitha Loganathan on 21/09/23.
//

import UIKit



class ViewController: UIViewController {
  
    var data  = [
        Person(firstName: "John", lastName: "Smith", gender: "Male", height: 170, age: 30),
        Person(firstName: "Dave", lastName: "Dillard", gender: "Male", height: 170, age: 23),
        Person(firstName: "Rob", lastName: "Walker", gender: "Male", height: 170, age: 15)
    ]

    private lazy var tableView : UITableView =  {
        let tableView = UITableView()
        tableView.register(CustomViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupTableView()
    }

    func setupTableView(){
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    

}

extension ViewController :  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomViewCell else {
            fatalError()
        }
        let model = data[indexPath.row]
        let viewModel = PersonViewModel(firstName: model.firstName, lastName: model.lastName)
        cell.configureView(with: viewModel)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

struct Person {
    let firstName: String
    let lastName: String
    let gender: String
    let height: Double
    let age: Double
}


struct PersonViewModel {
    let firstName: String
    let lastName: String
}
