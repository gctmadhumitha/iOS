//
//  PersonCollectionViewCell.swift
//  MVVM-UIKit-Project
//
//  Created by Madhumitha Loganathan on 26/09/23.
//

import UIKit

protocol PersonCollectionViewCellDelegate : AnyObject {
    func didTapSubscribe()
    
}

class PersonCollectionViewCell: UICollectionViewCell {
    
    private var personView : PersonView?
    
    weak var delegate : PersonCollectionViewCellDelegate?
    
    var item: PersonResponse? {
        didSet {
            guard let firstName = item?.firstName,
                  let lastName = item?.lastName,
                  let email = item?.email else {
                return
            }
            personView?.set(name: "\(firstName) \(lastName)", email: email)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not impelemnted")
    }
    
}

private extension PersonCollectionViewCell {
    
    func setup() {
        
        guard personView == nil else { return }
        
         personView = PersonView { [weak self] in
            self?.delegate?.didTapSubscribe()
        }
        
        guard let personView = personView else {
            return
        }
        
        personView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(personView)
        
        NSLayoutConstraint.activate([
            personView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:8),
            personView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:-8),
            personView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            personView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            
        ])
    }
    
}

extension PersonCollectionViewCell : PersonCollectionViewCellDelegate {
    func didTapSubscribe() {
        print("subscribe")
    }
}
