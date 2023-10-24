//
//  SwipeCardView.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 12/09/23.
//

import UIKit

final class SwipeCardView : UIView {
   
    //MARK: - Properties
    var swipeView : UIView!
    var shadowView : UIView!
    
    var headerLabel = UILabel()
    var factLabel = UILabel()
    
    var delegate : SwipeCardsDelegate?

    var divisor : CGFloat = 0
    let baseView = UIView()
    
    var dataSource : FactDataModel? {
        didSet {
            swipeView.backgroundColor = AppColors.gradientColor1
            factLabel.text = dataSource?.text
        }
    }
    
    
    //MARK: - Init
     override init(frame: CGRect) {
        super.init(frame: .zero)
        configureShadowView()
        configureSwipeView()
        configureLabelView()
        addPanGestureOnCards()
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
        swipeView.addSubview(headerLabel)
        swipeView.addSubview(factLabel)
        headerLabel.text = "Did you know? "
        headerLabel.textAlignment = .center
        headerLabel.textColor = AppColors.yellowColor
        headerLabel.font = UIFont.preferredFont(forTextStyle: .title1).bold()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: swipeView.topAnchor, constant: 20).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: swipeView.leadingAnchor, constant: 8).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: swipeView.trailingAnchor, constant: -8).isActive = true
        
        factLabel.textColor = .white
        factLabel.numberOfLines = 0
        factLabel.textAlignment = .center
        factLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        factLabel.translatesAutoresizingMaskIntoConstraints = false
        factLabel.topAnchor.constraint(equalTo: headerLabel.topAnchor, constant: 8).isActive = true
        factLabel.leadingAnchor.constraint(equalTo: swipeView.leadingAnchor, constant: 8).isActive = true
        factLabel.trailingAnchor.constraint(equalTo: swipeView.trailingAnchor, constant: -8).isActive = true
        factLabel.bottomAnchor.constraint(equalTo: swipeView.bottomAnchor, constant: -8).isActive = true
        factLabel.lineBreakMode = .byWordWrapping
        factLabel.contentScaleFactor = 2.0
        factLabel.minimumScaleFactor = 0.5
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

  
}
