//
//  ViewController.swift
//  MVVM-UIKit-Project
//
//  Created by Madhumitha Loganathan on 26/09/23.
//

import UIKit
import SafariServices

class PeopleViewController: UIViewController {
    
    private let vm = PeopleViewModel()
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width, height: 110)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: "PersonCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        return collectionView
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        vm.delegate = self
        vm.getUsers()
    }
}

extension PeopleViewController {
    func setup(){
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant:8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:-8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
    }
}

extension PeopleViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("vm.people.count : \(vm.people.count)")
        return vm.people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCollectionViewCell", for: indexPath) as! PersonCollectionViewCell
        print("vm.people[indexPath.item] \(vm.people[indexPath.item])")
        cell.item = vm.people[indexPath.item]
        cell.contentView.isUserInteractionEnabled = false
        cell.delegate = self
        return cell
    }
}

extension PeopleViewController: PeopleViewModelDelegate {
    func didFinish() {
        self.collectionView.reloadData()
    }
    
    func didFail(error: Error) {
        print(error)
    }
}

extension PeopleViewController : PersonCollectionViewCellDelegate {
    func didTapSubscribe() {
        print("didTapSubscribe called")
        
        let url = URL(string: "https://www.google.com")!
        let vc = SFSafariViewController(url:url)
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true)
    }
}
