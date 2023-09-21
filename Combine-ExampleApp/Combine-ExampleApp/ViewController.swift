//
//  ViewController.swift
//  Combine-ExampleApp
//
//  Created by Madhumitha Loganathan on 20/09/23.
//

import UIKit
import Combine

class CustomTableViewCell : UITableViewCell {
    private let button : UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func  layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x:10, y:3, width:contentView.frame.size.width-20, height: contentView.frame.size.height-10)
    }
}

class ViewController: UIViewController, UITableViewDataSource {

    private let tableView: UITableView = {
       let table = UITableView()
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var observer: AnyCancellable?
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        observer = APIHelper.shared.fetchCompanies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            switch completion {
                case .finished:
                    print("finished")
                    
                case .failure(let error):
                    print("failure", error)
                }
            }, receiveValue: { [weak self] value in
            self?.models = value
            print("models", value)
            self?.tableView.reloadData()
        })
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt" , indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else{
            fatalError()
        }
        cell.textLabel?.text = models[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

}

