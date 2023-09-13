//
//  SwipeCardsDataSource.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 12/09/23.
//

import UIKit

protocol SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int
    func card() async -> SwipeCardView
    func emptyView() -> UIView?
    
}

protocol SwipeCardsDelegate {
    func swipeDidEnd(on view: SwipeCardView)
}

