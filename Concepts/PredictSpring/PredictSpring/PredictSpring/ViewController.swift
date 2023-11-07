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
    var searchedProducts = [Product]()
    var searchText = ""
    var prevSearchText = ""
    var isNewSearch = true
    
    
// MARK: - Views
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = .gray
        progressView.progressTintColor = .blue
        return progressView
    }()
    
    private let dbStatusLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: .caption1)
        lbl.textAlignment = .left
        lbl.text = "Database Insert : Not started"
        return lbl
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
        view.addSubview(dbStatusLabel)
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
        
        //searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func layoutConstraints(){
        
        progressView.anchor(top: view.layoutMarginsGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.size.width - 20, height: 25, enableInsets: false)
        
        dbStatusLabel.anchor(top: progressView.bottomAnchor, left: view.leftAnchor, bottom: tableView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.size.width - 20, height: 0, enableInsets: false)
        
        tableView.anchor(top: dbStatusLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        
        
        
        
//          NSLayoutConstraint.activate([
//               progressView.heightAnchor.constraint(equalToConstant: 25),
//               progressView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 20),
//               progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//               progressView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0),
//               
//              
//               
//               
//               tableView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
//               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//               
//         ])
       }
    
}


extension ViewController {
    
    func fetchData(isFirst: Bool = true){
        let isNewSearch  = ( prevSearchText != searchText ) ? true : false
        viewModel.fetchProducts(id: searchText.trimmingCharacters(in: .whitespacesAndNewlines), isNewSearch : isNewSearch)
        prevSearchText = searchText
        //reload for pagination
        if !isFirst || isNewSearch {
            self.tableView.reloadData()
        }
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
        DispatchQueue.global(qos: .background).async {
            self.viewModel.insert (url: fileUrl){ [weak self] value in
                self?.showInsertProgress(value: value)
            } completionHandler: { [weak self]  status in
                self?.showInsertCompletion(status: status)
            }
        }
    }
    
    func showDownloadProgress(value: Float) {
        self.progressView.progress = value
    }
    
    func showDownloadCompletion(status: DownloadStatus){
        print("showDownloadCompletion", status)
        if case DownloadStatus.completed(let url) = status {
            self.progressView.fadeOut()
//            self.tableView.fadeIn()
//            self.tableView.reloadData()
            self.insertData(fileUrl: url)
        } else{
            self.progressView.fadeOut()
        }
    }
    
    func showInsertProgress(value: Float) {
        print("showInsertProgress " , value)
        DispatchQueue.main.async {
            self.dbStatusLabel.text = "Inserted \(value) rows"
        }
    }
    
    func showInsertCompletion(status: DatabaseStatus){
        print("showInsertCompletion ", status)
        if case .completed(let value) = status {
            self.dbStatusLabel.text = "All rows inserted : \(value)"
        }
        else {
            self.dbStatusLabel.text = "Database Insertion failed"
        }
        
    }
}


// Implementation for TableView Delegate methods
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("row : \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseIdentifier, for: indexPath) as! ProductCell
//        if (hasSearchText) {
//            cell.product = searchedProducts[indexPath.row]
//        }
//        else {
            cell.product = viewModel.products[indexPath.row]
       // }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("willDisplay")
        if indexPath.row == viewModel.totalCount - 1 && !viewModel.hasReachedEndOfProducts {
            fetchData(isFirst: false)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection ", viewModel.totalCount)
 //         if (hasSearchText) {
//           return searchedProducts.count
//        }
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



//// Implementation for SearchController Delegate methods
extension ViewController : UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        isNewSearch = false
        searchText = searchController.searchBar.searchTextField.text ?? ""
        print("updateSearchResults searchText is \(searchText)")
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            searchedProducts = viewModel.products.filter {
                $0.title.contains(searchText)
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
        searchText = searchController.searchBar.searchTextField.text ?? ""
        fetchData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
        searchText = ""
    }
}

