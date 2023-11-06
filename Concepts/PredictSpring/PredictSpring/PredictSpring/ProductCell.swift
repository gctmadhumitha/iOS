//
//  ProductTableViewCell.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 06/11/23.
//

import UIKit

import UIKit
class ProductCell : UITableViewCell {
    
    static let reuseIdentifier  = "ProductCell"
    var product : Product? {
        didSet {
            productTitleLabel.text = product?.title
            productColorLabel.text = product?.color
            productSizeLabel.text = product?.size
            productIdLabel.text = product?.productId
            productListPriceLabel.text =  String(format: "Tip Amount: $%.02f", product?.listPrice ?? "$0")
            productSalePriceLabel.text =  String(format: "Tip Amount: $%.02f", product?.salesPrice ?? "$0")
        }
    }
    
    private let productTitleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: .title3)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let productColorLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let productSizeLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let productIdLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: .footnote)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let productListPriceLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: .caption1)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let productSalePriceLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.preferredFont(forTextStyle: .caption1)
        lbl.textAlignment = .left
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(productTitleLabel)
        addSubview(productColorLabel)
        addSubview(productSizeLabel)
        
        addSubview(productIdLabel)
        addSubview(productListPriceLabel)
        addSubview(productSalePriceLabel)
        
        let topStackView = UIStackView(arrangedSubviews: [productTitleLabel,productColorLabel,productSizeLabel])
        topStackView.distribution = .fillProportionally
        topStackView.axis = .horizontal
        topStackView.spacing = 5
        addSubview(topStackView)
        
        let bottomStackView = UIStackView(arrangedSubviews: [productIdLabel,productListPriceLabel,productSalePriceLabel])
        bottomStackView.distribution = .fillProportionally
        bottomStackView.axis = .horizontal
        bottomStackView.spacing = 5
        addSubview(bottomStackView)
        
        topStackView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 15, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        bottomStackView.anchor(top: topStackView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 15, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
