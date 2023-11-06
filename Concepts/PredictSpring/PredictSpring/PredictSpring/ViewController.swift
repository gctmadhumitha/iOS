//
//  ViewController.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 03/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    let fileUrl =   "https://drive.google.com/uc?export=download&id=1XSrB4N6d6918JRobJ3Fx14JDa_ZsnMAO"
    var viewModel = ProductsViewModel()
    
    
   
    
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
        fetchData()
    }


    func layoutUI()
    {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseIdentifier)
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
    

}


extension ViewController {
    
    func fetchData(isFirst: Bool = true){
        viewModel.fetchProducts()
        if !isFirst {
            self.tableView.reloadData()
        }
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
        if case DownloadStatus.completed(let _) = status {
            self.progressView.fadeOut()
            self.tableView.fadeIn()
            self.tableView.reloadData()
//            self.viewModel.fileUrl = url
        } else{
            self.progressView.fadeOut()
        }
        
    }
}


// Implementation for TableView Delegate methods
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("row : \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseIdentifier, for: indexPath) as! ProductCell
        cell.product = viewModel.products[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("viewModel.products.count : \(viewModel.products.count)")
        if indexPath.row == viewModel.totalCount - 1 {
            fetchData(isFirst: false)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection - \(viewModel.totalCount)")
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        /// UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        /// Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            fetchData()
        }
    }
    
}



// Implementation for SearchController Delegate methods
extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}

