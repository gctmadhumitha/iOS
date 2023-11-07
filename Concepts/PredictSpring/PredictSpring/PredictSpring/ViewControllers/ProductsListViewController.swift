//
//  ViewController.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 03/11/23.
//

import UIKit

class ProductsListViewController: UIViewController {
    
    let fileUrl =   Constants.file_url
    var viewModel = ProductsViewModel()
    var searchedProducts = [Product]()
    var searchText = ""
    var prevSearchText = ""
    var isNewSearch = true
    
    
    // MARK: - Views
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = .gray
        progressView.progressTintColor = .black
        progressView.trackTintColor = .clear
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 5
        progressView.layer.borderWidth = 1.0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let downloadProgressLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: .caption1)
        lbl.textAlignment = .left
        lbl.text = "Downloading...."
        return lbl
    }()
    
    private let dbProgressLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: .caption1)
        lbl.textAlignment = .left
        lbl.text = "Save records to db : Not initiated"
        return lbl
    }()
    
    
    private let statusContainer : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var tableView: UITableView  = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        return button
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Enter product name"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    private lazy var isDownloadComplete = UserDefaults.standard.bool(forKey: Constants.isDownloadComplete)
    private lazy var isDatabaseSaveComplete = UserDefaults.standard.bool(forKey: Constants.isDatabaseSaveComplete)
    
    
    // MARK: - Main methods
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        if (isDownloadComplete && isDatabaseSaveComplete){
            progressView.progress = 1
            downloadProgressLabel.text = "File downloaded from google drive"
            dbProgressLabel.text = "Records saved to SQLite database"
            fetchData()
        } else {
            downloadData(url: fileUrl)
        }
    }
    
    // Lays out UI components in the view
    func layoutUI()
    {
        statusContainer.addArrangedSubview(progressView)
        statusContainer.addArrangedSubview(downloadProgressLabel)
        statusContainer.addArrangedSubview(dbProgressLabel)
        view.addSubview(statusContainer)
        view.backgroundColor = .white
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        view.addSubview(tableView)
        
        layoutConstraints()
    }
   
    // Defines auto layout constraints
    func layoutConstraints(){
        progressView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: view.frame.size.width - 20, height: 20, enableInsets: false)
        
        statusContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: tableView.topAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: view.frame.size.width - 20, height: 0, enableInsets: true)
        
        tableView.anchor(top: statusContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0, enableInsets: false)
    }
    
}


// Methods to perform Download and Database operations
extension ProductsListViewController {
    
    func fetchData(isFirst: Bool = true){
        let isNewSearch  = ( prevSearchText != searchText ) ? true : false
        viewModel.fetchProducts(id: searchText.trimmingCharacters(in: .whitespacesAndNewlines), isNewSearch : isNewSearch)
        prevSearchText = searchText
        //Reload for pagination
       // if !isFirst || isNewSearch {
            self.tableView.fadeIn()
            self.tableView.reloadData()
       // }
    }
    
    func downloadData(url: String){
        /// load downloadTask
        viewModel.download(url: url) {  [weak self] value in
            self?.showDownloadProgress(value: value)
        } completionHandler: { [weak self]  status in
            self?.showDownloadCompletion(status: status)
        }
    }
    
    func insertData(fileUrl: URL){
        if !isDatabaseSaveComplete {
            DispatchQueue.global(qos: .background).async {
                self.viewModel.insert (url: fileUrl){ [weak self] value in
                    self?.showInsertProgress(value: value)
                } completionHandler: { [weak self]  status in
                    self?.showInsertCompletion(status: status)
                }
            }
        } else{
            fetchData(isFirst: true)
        }
    }
}



// TableView Delegate methods
extension ProductsListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseIdentifier, for: indexPath) as! ProductCell
        cell.product = viewModel.products[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.totalCount - 1 && !viewModel.hasReachedEndOfProducts {
            fetchData(isFirst: false)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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



// SearchBar Delegate methods
extension ProductsListViewController : UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchText = searchController.searchBar.searchTextField.text ?? ""
        fetchData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchText = ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = ""
        fetchData()
    }
    
}


// Completion Handlers for Download and Save tasks
// Could use delegate too 
extension ProductsListViewController {
    func showDownloadProgress(value: Float) {
        self.progressView.progress = value
    }
    
    func showDownloadCompletion(status: DownloadStatus){
        self.downloadProgressLabel.text = "Download complete"
        
        if case DownloadStatus.completed(let url) = status
        {
            if !isDatabaseSaveComplete  {
                self.insertData(fileUrl: url)
            }
        }
        else {
            downloadProgressLabel.text = "Download error"
        }
    }
    
    func showInsertProgress(value: Int) {
        DispatchQueue.main.async {
            self.dbProgressLabel.text = " \(value) records saved"
        }
    }
    
    func showInsertCompletion(status: DatabaseStatus){
        if case .completed(let value) = status {
            self.dbProgressLabel.text = "All records saved : \(value)"
            fetchData(isFirst: true)
        }
        else {
            self.dbProgressLabel.text = "Failed to save records to the database"
        }
    }
}
