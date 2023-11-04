//
//  ViewController.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 03/11/23.
//

import UIKit

//class ViewController: UIViewController {
//
//    let products = ["one", "two", "three", "four", "five"]
//
//
//    lazy var progressView: UIProgressView = {
//        let progressView = UIProgressView()
//        progressView.translatesAutoresizingMaskIntoConstraints = false
//        return progressView
//    }()
//
////    lazy var tableView: UITableView  = {
////        tableView = UITableView()
////        tableView.frame = view.bounds
////        return tableView
////    }()
////
////    lazy var searchController: UISearchController = {
////        let searchController = UISearchController(searchResultsController: nil)
////        searchController.searchBar.placeholder = "Enter product name"
////        searchController.searchBar.searchBarStyle = .minimal
////        return searchController
////    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        layoutUI()
//
//    }
//
//    func layoutUI()
//    {
//          view.addSubview(progressView)
//          layoutConstraints()
//
////        view.addSubview(tableView)
////        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
////        tableView.delegate = self
////        tableView.dataSource = self
////
////        searchController.searchResultsUpdater = self
////        searchController.obscuresBackgroundDuringPresentation = false
////        navigationItem.searchController = searchController
////        navigationItem.hidesSearchBarWhenScrolling = false
////        definesPresentationContext = true
//        progressView.setProgress(0.0, animated: false)
//
//        let downloadManager = DownloadManager()
//        downloadManager.downloadDelegate = self
//        downloadManager.start(file: "https://drive.google.com/file/d/1XSrB4N6d6918JRobJ3Fx14JDa_ZsnMAO/view?usp=drive_link")
//    }
//
//    func layoutConstraints(){
//        NSLayoutConstraint.activate([
//            progressView.heightAnchor.constraint(equalToConstant: 50),
//            progressView.widthAnchor.constraint(equalToConstant: 100),
//            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//     ])
//
//
//    }
//
//}
//
//// Implementation for TableView Delegate methods
//extension ViewController : UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
//        cell.textLabel?.text = products[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return products.count
//    }
//}
//
//
//// Implementation for SearchController Delegate methods
//extension ViewController : UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        // TODO
//    }
//
//}
//
//
//


class ViewController: UIViewController {
    
    let fileUrl =   "https://drive.google.com/uc?export=download&id=1XSrB4N6d6918JRobJ3Fx14JDa_ZsnMAO"
    let products = ["one", "two", "three"]
    
// MARK: - Views
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = .gray
        progressView.progressTintColor = .blue
        return progressView
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
    
// MARK: - Properties
    var downloadTask: DownloadManager!
    
// MARK: - Main methods
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        downloadData(url: fileUrl)
    }
    

    func layoutUI()
    {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubview(progressView)
        view.addSubview(tableView)
        layoutConstraints()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
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
               
               tableView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
               
         ])
       }

}

// Closures for Download Progress
extension ViewController {
    func downloadData(url: String){
        /// load downloadTask
        DownloadManager().download(url: url) {  [weak self] value in
           self?.showDownloadProgress(value: value)
        } completion: { [weak self]  value in
            self?.showDownloadCompletion(value: value)
        }
    }
    
    func showDownloadProgress(value: Float) {
        print("showDownloadProgress", value)
        self.progressView.progress = value
    }
    
    func showDownloadCompletion(value: Bool){
        print("showDownloadCompletion", value)
            self.progressView.fadeOut()
            self.tableView.fadeIn()
            self.tableView.reloadData()
    }
}


// Implementation for TableView Delegate methods
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = products[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
}


// Implementation for SearchController Delegate methods
extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }

}


