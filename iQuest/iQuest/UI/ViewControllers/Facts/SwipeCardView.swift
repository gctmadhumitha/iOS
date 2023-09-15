//
//  SwipeCardView.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 12/09/23.
//

import UIKit

class SwipeCardView : UIView {
   
    //MARK: - Properties
    var swipeView : UIView!
    var shadowView : UIView!
    
    var label = UILabel()
    //var moreButton = UIButton()
    
    var delegate : SwipeCardsDelegate?

    var divisor : CGFloat = 0
    let baseView = UIView()

    
    
    var dataSource : FactDataModel? {
        didSet {
            swipeView.backgroundColor = AppColors.primaryAppColor
            label.text = dataSource?.text
        }
    }
    
    
    //MARK: - Init
     override init(frame: CGRect) {
        super.init(frame: .zero)
        configureShadowView()
        configureSwipeView()
        configureLabelView()
        //configureButton()
        addPanGestureOnCards()
        configureTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration
    
    func configureShadowView() {
        shadowView = UIView()
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = AppColors.shadowColor?.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowRadius = 2.0
        addSubview(shadowView)

        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        shadowView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }

    func configureSwipeView() {
        swipeView = UIView()
        swipeView.layer.cornerRadius = 15
        swipeView.clipsToBounds = true
        shadowView.addSubview(swipeView)

        swipeView.translatesAutoresizingMaskIntoConstraints = false
        swipeView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 10).isActive = true
        swipeView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -10).isActive = true
        swipeView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
        swipeView.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
    }

    func configureLabelView() {
        swipeView.addSubview(label)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: swipeView.topAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: swipeView.leadingAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: swipeView.trailingAnchor, constant: -8).isActive = true
        label.bottomAnchor.constraint(equalTo: swipeView.bottomAnchor, constant: -8).isActive = true
        label.lineBreakMode = .byWordWrapping
        label.contentScaleFactor = 2.0
        label.minimumScaleFactor = 0.5
    }

    
//    func configureButton() {
//        label.addSubview(moreButton)
//        moreButton.translatesAutoresizingMaskIntoConstraints = false
//        let image = UIImage(named: "plus-tab")?.withRenderingMode(.alwaysTemplate)
//        moreButton.setImage(image, for: .normal)
//        moreButton.tintColor = UIColor.red
//
//        moreButton.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: -15).isActive = true
//        moreButton.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
//        moreButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        moreButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//    }

    func configureTapGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    
    func addPanGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    
    
    //MARK: - Handlers
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        let card = sender.view as! SwipeCardView
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        
        let distanceFromCenter = ((UIScreen.main.bounds.width / 2) - card.center.x)
        divisor = ((UIScreen.main.bounds.width / 2) / 0.61)
       
        switch sender.state {
        case .ended:
            if (card.center.x) > 400 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }else if card.center.x < -65 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.layoutIfNeeded()
            }
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            
        default:
            break
        }
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer){
    }
    
  
}
