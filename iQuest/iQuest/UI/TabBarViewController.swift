
//
//  ListViewController.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 01/09/23.
//

import UIKit
import SwiftUI

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    
    func setupUI(){
        
        self.view.backgroundColor = .systemBackground
        let tab1ViewController = TriviaViewController()
        let tabItem1 = UITabBarItem(title: "Trivia", image: UIImage(systemName:  "circle"),
                                    selectedImage: UIImage(systemName: "circle.fill"))
        tab1ViewController.tabBarItem = tabItem1
        
        let layout = UICollectionViewFlowLayout()
        let tab2ViewController  = FactsViewController(collectionViewLayout: layout)
        let tabItem2 = UITabBarItem(title: "Facts", image: UIImage(systemName:  "square"),selectedImage: UIImage(systemName: "square.fill"))
        tab2ViewController.tabBarItem = tabItem2
        
        let tab3ViewController  = UIHostingController(rootView:ChatView())
        let tabItem3 = UITabBarItem(title: "Chat GPT", image: UIImage(systemName:  "heart"),selectedImage: UIImage(systemName: "heart.fill"))
        tab3ViewController.tabBarItem = tabItem3
        
        self.viewControllers = [tab1ViewController, tab2ViewController, tab3ViewController]
        
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("tab bar printed", item.title ?? "nil")
    }
    
}
