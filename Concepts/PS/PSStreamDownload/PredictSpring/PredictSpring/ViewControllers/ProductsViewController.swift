//
//  ProductsViewController.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 05/11/23.
//

import UIKit


// Main ViewController to display the records from the file and to lookup by product Id
class ProductsViewController: UIViewController {
    
    private var viewModel = ProductsViewModel()
    private var searchText = ""
    private var prevSearchText = ""
    private var isNewSearch = true
    
    private lazy var progressLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(hex: "#008080ff")
        lbl.font = UIFont.subheadline.with(weight: .bold)
        lbl.textAlignment = .left
        lbl.text = "No records saved to database"
        return lbl
    }()
    
    
    private lazy var statusContainer : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var tableView: UITableView  = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Enter Product Id"
        searchController.searchBar.isUserInteractionEnabled = true
        searchController.searchBar.searchBarStyle = .minimal
        return searchController

    }()
    

    private lazy var isProcessingDone : Bool = {
       return UserDefaults.standard.bool(forKey: Constants.isProcessingDone)
    }()
    
    private var statusHeightAnchor : NSLayoutConstraint?
    
    private var startTime : Date?
    // MARK: - Main methods
    override func viewDidLoad(){
        super.viewDidLoad()
        startTime = Date()
        print("Start Time is", startTime)
        layoutUI()
        isProcessingDone = UserDefaults.standard.bool(forKey: Constants.isProcessingDone)
        if isProcessingDone {
            statusHeightAnchor?.constant = 0
            progressLabel.text = ""
            fetchData()
        } else {
            downloadData(url: Constants.fileUrl)
        }
    }
    
    // Lays out UI components in the view
    func layoutUI(){
        statusContainer.addArrangedSubview(progressLabel)
        statusHeightAnchor = statusContainer.heightAnchor.constraint(equalToConstant: 80)
        statusHeightAnchor?.isActive = true
        view.addSubview(statusContainer)
        view.backgroundColor = .systemBackground
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(reload))
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.title = "PredictSpring"
        definesPresentationContext = true
        view.addSubview(tableView)
        toggleSearchBar()
        layoutConstraints()
    }
    
    
    
    // Defines auto layout constraints
    func layoutConstraints(){

        statusContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: tableView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.size.width - 20, height: 0, enableInsets: true)
        tableView.anchor(top: statusContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0, enableInsets: false)
    }
    
}


// Methods to perform Download and Database operations
extension ProductsViewController {
    
    @objc func reload(){
        print("Reload ")
        let isDeleteSuccessful = self.viewModel.deleteAllProducts()
        self.statusHeightAnchor?.constant = 80
        UIView.animate(withDuration: 0.3, animations:{
            self.statusContainer.layoutIfNeeded()
        })
        tableView.reloadData()
        print("isDeleteSuccessful")
        if isDeleteSuccessful {
            downloadData(url: Constants.fileUrl)
        }
    }
    
    func fetchData(isFirst: Bool = true){
        let isNewSearch  = ( prevSearchText != searchText ) ? true : false
        viewModel.fetchProducts(id: searchText.trimmingCharacters(in: .whitespacesAndNewlines), isNewSearch : isNewSearch)
        prevSearchText = searchText
        //Reload for pagination
        self.tableView.fadeIn()
        self.tableView.reloadData()
    }
    
    func downloadData(url: String){
        /// load downloadTask
        startTime = Date()
        viewModel.downloadStreamAndInsert(url: url) {  [weak self] value in
            //print("I m in progress handler", self?.viewModel.getRowCount())
            self?.showProgress(value: Int(value))
        } completionHandler: { [weak self]  status in
            self?.showCompletion(status: status)
            //self?.fetchData(isFirst: true)
        }
    }
}



// TableView Delegate methods
extension ProductsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseIdentifier, for: indexPath) as! ProductCell
        cell.product = viewModel.products[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /// Pagination logic
        if indexPath.row == viewModel.totalCount - 1 && !viewModel.hasReachedEndOfProducts {
            fetchData(isFirst: false)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalCount = viewModel.totalCount
        /// Empty state for tableview
        let emptyView = EmptyView(frame: tableView.bounds)
        emptyView.headerTitle.text = searchText.count > 0 ? "No matching records ": ""
        tableView.backgroundView = (totalCount == 0 && isProcessingDone) ? emptyView : nil
        return totalCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// Delegate method for Pagination
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
extension ProductsViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchText = ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = ""
        fetchData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        fetchData()
    }
    
    func toggleSearchBar(){
        /// Enable Search bar after records are inserted into database
        isProcessingDone = UserDefaults.standard.bool(forKey: Constants.isProcessingDone)
    }
    
}


// Completion Handlers
// Could use protocols/delegates too
extension ProductsViewController {
    
    /// Progress hander to update UI with the number of records processed
    func showProgress(value: Int) {
        DispatchQueue.main.async {
            self.progressLabel.text = "\(value) records"
        }
    }
    
    /// Completion Handler called after all records are saved
    func showCompletion(status: DatabaseStatus){
        if let startTime = startTime {
            let totalTime = Date().timeIntervalSince(startTime)
            print("Total Time is \(Int(totalTime)) seconds")
        }
        DispatchQueue.main.async {
            let val = String(self.viewModel.getRowCount() ?? 0)
            if case .completed(let value) = status {
                self.progressLabel.text = "\(val) records"
                self.toggleSearchBar()
                self.statusHeightAnchor?.constant = 0
                UIView.animate(withDuration: 0.3, animations:{
                    self.statusContainer.layoutIfNeeded()
                })
                print("self.viewModel.getRowCount() ", self.viewModel.getRowCount())
                self.fetchData(isFirst: true)
            }
            else {
                self.progressLabel.text = "Failed to save records to the database"
            }
            // create the alert
            let alert = UIAlertController(title: "Download complete", message: "\(val) records saved.", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
}
