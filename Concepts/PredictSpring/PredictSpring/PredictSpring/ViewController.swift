//
//  ViewController.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 03/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    let fileUrl =   "https://drive.google.com/uc?export=download&id=1XSrB4N6d6918JRobJ3Fx14JDa_ZsnMAO"
    //let products = ["one", "two", "three"]
    
    var viewModel: ViewModel = ViewModel()
   
    
// MARK: - Views
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = .gray
        progressView.progressTintColor = .blue
        return progressView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Insert To Db", for: .normal)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private lazy var button2: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Data", for: .normal)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private lazy var tableView: UITableView  = {
        let tableView = UITableView()
        return tableView
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Enter product name"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
// MARK: - Main methods
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        downloadData(url: fileUrl)
        viewModel.get()
    }
    

    func layoutUI()
    {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubview(progressView)
        //view.addSubview(button)
       // button.addTarget(self, action: #selector(insertToDb), for: .touchUpInside)
        //view.addSubview(button2)
        //button2.addTarget(self, action: #selector(getData), for: .touchUpInside)
        view.addSubview(tableView)
        layoutConstraints()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.isHidden = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func layoutConstraints(){
          NSLayoutConstraint.activate([
               progressView.heightAnchor.constraint(equalToConstant: 25),
               progressView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 20),
               progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               progressView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0),
               
//               button.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 80),
//               button.heightAnchor.constraint(equalToConstant: 50),
//               button.widthAnchor.constraint(equalToConstant: 120),
//               button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//               
//               button2.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 80),
//               button2.heightAnchor.constraint(equalToConstant: 50),
//               button2.widthAnchor.constraint(equalToConstant: 120),
//               button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               
               tableView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
               
         ])
       }
    
    @objc func insertToDb(sender: UIButton){
        viewModel.insert()
    }
    
    @objc func getData(sender: UIButton){
        viewModel.get()
    }
}

// Closures for Download Progress
extension ViewController {
    func downloadData(url: String){
        /// load downloadTask
        viewModel.download(url: url) {  [weak self] value in
           self?.showDownloadProgress(value: value)
        } completion: { [weak self]  status in
            self?.showDownloadCompletion(status: status)
        }
    }
    
    func showDownloadProgress(value: Float) {
        print("showDownloadProgress", value)
        self.progressView.progress = value
    }
    
    func showDownloadCompletion(status: DownloadStatus){
        print("showDownloadCompletion", status)
        if case DownloadStatus.completed(let url) = status {
            self.progressView.fadeOut()
//            self.tableView.fadeIn()
//            self.tableView.reloadData()
            self.viewModel.fileUrl = url
        } else{
            self.progressView.fadeOut()
        }
        
    }
}


// Implementation for TableView Delegate methods
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = viewModel.products[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
}


// Implementation for SearchController Delegate methods
extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }

}


