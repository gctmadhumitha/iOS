//
//  EmptyView.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 07/11/23.
//

import UIKit

class EmptyView: UIView {
    
    
    lazy var headerTitle: UILabel = {
        let headerTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        headerTitle.font = UIFont.preferredFont(forTextStyle: .body)
        headerTitle.textColor = .darkGray
        headerTitle.text = "No matching records found"
        headerTitle.textAlignment = .center
        return headerTitle
    }()
    
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        headerView.addSubview(headerTitle)
        return headerView
    }()
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        headerView.frame = frame
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        addSubview(headerView)   
        setupLayout()
    }
    
    private func setupLayout() {
        
        headerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        headerTitle.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 100, paddingRight: 0, width: 0, height: 0, enableInsets: false)
      
        
      }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
      }
    
    override var intrinsicContentSize: CGSize {
      //preferred content size, calculate it if some internal state changes
      return CGSize(width: 300, height: 300)
    }
    
}
