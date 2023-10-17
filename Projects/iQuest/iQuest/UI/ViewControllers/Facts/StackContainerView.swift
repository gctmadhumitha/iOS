//
//  StackContainerController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 12/09/23.
//

import UIKit


final class StackContainerView: UIView, SwipeCardsDelegate {

    //MARK: - Properties
    var cardsToBeVisible: Int = 3
    var cardViews : [SwipeCardView] = []
    
    let horizontalInset: CGFloat = 10.0
    let verticalInset: CGFloat = 10.0
    
    var visibleCards: [SwipeCardView] {
        return subviews as? [SwipeCardView] ?? []
    }
    var dataSource: SwipeCardsDataSource? {
        didSet {
            reloadData()
        }
    }
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func reloadData()  {
        removeAllCardViews()
        guard let datasource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
     
        Task {
            for i in 0..<cardsToBeVisible {
                let card = await datasource.card()
                addCardView(cardView: card, atIndex: i )
            }
        }
    }

    //MARK: - Configurations

    private func addCardView(cardView: SwipeCardView, atIndex index: Int) {
        cardView.delegate = self
        addCardFrame(index: index, cardView: cardView)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
   
    }
    
    func addCardFrame(index: Int, cardView: SwipeCardView) {
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * self.horizontalInset)
        let verticalInset = CGFloat(index) * self.verticalInset
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        
        cardView.frame = cardViewFrame
    }
    
    private func removeAllCardViews() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
    
    func swipeDidEnd(on view: SwipeCardView) {
        guard let datasource = dataSource else { return }
        view.removeFromSuperview()
        Task {
            let card = await datasource.card()
            addCardView(cardView: card, atIndex: 2)
        }
        
        for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
            UIView.animate(withDuration: 0.2, animations: {
            cardView.center = self.center
              self.addCardFrame(index: cardIndex, cardView: cardView)
                self.layoutIfNeeded()
            })
        }

    }
    

}

