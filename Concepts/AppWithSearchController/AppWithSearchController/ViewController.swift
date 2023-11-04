//
//  ViewController.swift
//  AppWithSearchController
//
//  Created by Madhumitha Loganathan on 25/10/23.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {

    var places : [Place] = [] {
        didSet {
            filteredPlaces = places
        }
    }
    var filteredPlaces = [Place]()
    
    private var searchController: UISearchController = {
       let searchController = UISearchController(searchResultsController: nil)
       searchController.searchBar.placeholder = "Search Places"
       searchController.searchBar.searchBarStyle = .minimal
       return searchController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        fetchData()
    }
    
    func layoutUI(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
      
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func fetchData(){
        APIService.loadPlaces { [weak self] places in
            DispatchQueue.main.async {
                self?.places = places
                self?.tableView.reloadData()
            }
        }
    }
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredPlaces[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlaces.count
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.searchTextField.text ?? nil)
        tableView.reloadData()
    }
    
    func filterContentForSearchText(_ searchText: String?) {
        if let searchText = searchText, searchText.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            filteredPlaces = places.filter {
                $0.name.contains(searchText)
            }
           
        } else {
            filteredPlaces = places
        }
        
    }
}

